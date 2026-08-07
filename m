Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A8B3B38AD;
	Fri,  7 Aug 2026 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113799; cv=none; b=kbaMwu3RTQ4FscMZKHBXRpGdrnzXhrTv9LwvFIUxM1IbSUWAwVxIAxNkoQorsvD6TN/EY5E8nqaTyQzSwNAVC/O8vyefa7f2RJlrpqwHkSQxjQv9kyajk90ZeKY7LdrNaF0JqWttTMDHzm9GQyAVYM6ZXmLBQgk+967R/6pOtV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113799; c=relaxed/simple;
	bh=Mg1gXM5oUN3O0NSLefTH39L7G3e8u5KYW2RWxTVxFAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8oVpGX0ciAMJu8lAYhhp7rzqB8aBmHIauzpDGI5kO5EvKTMb6+vYe4ogIblrjUICqIl6rFY5FH4MHUhLcOfMzl0ITNjt3wkZ3EASvogpluhUvD9hp5lMcEF0U7OVyXy0K1ToKSMU8O4SnR4gNbqj01/awcH4mEEA1HEbT3es+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoBUGv3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoBUGv3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF2D1F00A3D;
	Fri,  7 Aug 2026 14:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113771;
	bh=xHEs5qRF7gMatqWt0QliCcBh9r2ATNY3CjQqNkWOzqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoBUGv3uG3onuWWh+rZxz7aUXx4FzZOeEIll+QuCSKKLy4GTas99kOlgtHinrzgdC
	 7a3BohvCvhW1pbeUWx5oT80tzlwjPw4otdItdzJ8n7GhnFga9rMb2vE24BnfvEzr1v
	 UbALO+tujARIl49JVqOKGOre7cCYd6wY1hkwxLoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/337] um: Set parent-death signal for write_sigio thread/process
Date: Fri,  7 Aug 2026 16:33:29 +0200
Message-ID: <20260807143418.659800352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

commit c6c4adee65969218b0b7b13f568fd2c6f2333373 upstream.

The write_sigio thread is not really a traditional thread. Set
the parent-death signal for it to ensure that it will be killed
if the UML kernel dies unexpectedly without proper cleanup.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20241024142828.2612828-4-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/sigio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index 9e71794839e8..9aac8def4d63 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -55,6 +55,7 @@ static int write_sigio_thread(void *unused)
 	int i, n, respond_fd;
 	char c;
 
+	os_set_pdeathsig();
 	os_fix_helper_signals();
 	fds = &current_poll;
 	while (1) {
-- 
2.53.0



