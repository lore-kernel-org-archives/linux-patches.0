Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B668DDC0;
	Tue, 14 May 2024 10:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682960; cv=none; b=o5vF9Ob6a61G8Qnj6+kAv9CFtmMrO5GMnNpWsIl97Wic37SBLG61QINuBZS+dyd76FYObnqVa0NBbvf4HNz5vWARk3dcn7elK3g8eG9ZX5p6dLgyFbeJUSfVf3erK8y2GDi1w8uQIGQ+Tw0Px/3pxp937sR10jMzMfaOeH/daoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682960; c=relaxed/simple;
	bh=zMb/K+nEME9CxALgTSF9tk6HFAEKDzzzTd5YEqhoxPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrN4xg3Z+iZsK1uvX4QqPiOZ3/RV3FBEcEH2xULLjw71Yz7tDHl8e/K7/NlHvSITOAIxCkxhtkRZdpjOEsymWw1sJxhph+QNCJDYO1Ce59EKcrWdiwAkha8VdhumDXqNzDePZeVgqcKxVteZs5YvxYIzPF/JXH1onh283NGOOsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIyF8M6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIyF8M6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5457C2BD10;
	Tue, 14 May 2024 10:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682960;
	bh=zMb/K+nEME9CxALgTSF9tk6HFAEKDzzzTd5YEqhoxPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIyF8M6u5iEnINXKYKP5+fvRp+XLBYaZJ5US159Wb2F3Y2xYVPlSlxxjK2d/MU0IG
	 hFE7ATy0w1rtnQnVsYNWgJXO72/qpFceAEE/Hxvv8KMnuGOD6/H56fbzVdg91z/QZ0
	 UXTsC8SvH891Ms9hCrlWtBu7f3WtzcQE5Bo/0w4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 140/336] tools/power turbostat: Fix warning upon failed /dev/cpu_dma_latency read
Date: Tue, 14 May 2024 12:15:44 +0200
Message-ID: <20240514101043.885926244@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit b6fe938317eed58e8c687bd5965a956e15fb5828 ]

Previously a failed read of /dev/cpu_dma_latency erroneously complained
turbostat: capget(CAP_SYS_ADMIN) failed, try "# setcap cap_sys_admin=ep ./turbostat

This went unnoticed because this file is typically visible to root,
and turbostat was typically run as root.

Going forward, when a non-root user can run turbostat...
Complain about failed read access to this file only if --debug is used.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index a4a40a6e1b957..3438ad938d7e4 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5545,7 +5545,8 @@ void print_dev_latency(void)
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
-		warnx("capget(CAP_SYS_ADMIN) failed, try \"# setcap cap_sys_admin=ep %s\"", progname);
+		if (debug)
+			warnx("Read %s failed", path);
 		return;
 	}
 
-- 
2.43.0



