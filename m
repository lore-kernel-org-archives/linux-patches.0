Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3EC1F8916;
	Tue,  3 Dec 2024 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237943; cv=none; b=CXwZPSfG+kyF7kAqUvX2VqW33hLBYsG0DRel0oAdJHsh2jv8hMV1gA0ifNq8Ye3+pZZyBj3/PWngFZ5sQaqo2XeovKIn7QRdMMHI5MnWZc0EUVlptu0xTZTXnCgyqZnF8MYsfv/gQIPxWIhrp+Z8+aMopHbeY5Iysb3oKu6G5Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237943; c=relaxed/simple;
	bh=Sg7YDY3Cc/GcRcaAFmtQW/LR9ah5VcvaUjAzttt40Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1taXTS05S7geBSVuo/bvDI1tgNdtt1IGpbXXv8MnXVlicraxo63q1zrvvCepjAlHrkOxp100NASLG8MeNmVtOnwDTYUa56XOJZwXuR/MMf+8cBW7ecDzuLGUkqQZlc3QlEYRkQer7G6gzhNhId6vDnDG11nrrN5Zuvx5rz21sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6nDgOGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6nDgOGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFDBC4CED6;
	Tue,  3 Dec 2024 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237943;
	bh=Sg7YDY3Cc/GcRcaAFmtQW/LR9ah5VcvaUjAzttt40Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6nDgOGSP1X1pKXtdzVlx/erkT+KGISIoIM/RYd9QFDyX+47yrVLsRnvScvxm+S93
	 rFBFz67E0KEG6fQjOTKjsHfZ19zjhDMM+il+aLsYkQo+OhvuBBhvEZe5CA1DHc6ygw
	 UA1RryFZEpD2EWFygreKNc3Na03eyVoOkp/mVJ6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 115/817] sched/cpufreq: Ensure sd is rebuilt for EAS check
Date: Tue,  3 Dec 2024 15:34:47 +0100
Message-ID: <20241203144000.203918628@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 70d8b6485b0bcd135b6699fc4252d2272818d1fb ]

Ensure sugov_eas_rebuild_sd() is always called when sugov_init()
succeeds. The out goto initialized sugov without forcing the rebuild.

Previously the missing call to sugov_eas_rebuild_sd() could lead to EAS
not being enabled on boot when it should have been, because it requires
all policies to be controlled by schedutil while they might not have
been initialized yet.

Fixes: e7a1b32e43b1 ("cpufreq: Rebuild sched-domains when removing cpufreq driver")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/35e572d9-1152-406a-9e34-2525f7548af9@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index eece6244f9d2f..9089ba62a2171 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -775,9 +775,8 @@ static int sugov_init(struct cpufreq_policy *policy)
 	if (ret)
 		goto fail;
 
-	sugov_eas_rebuild_sd();
-
 out:
+	sugov_eas_rebuild_sd();
 	mutex_unlock(&global_tunables_lock);
 	return 0;
 
-- 
2.43.0



