Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289CC335BA0;
	Mon, 18 Aug 2025 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524270; cv=none; b=DcTKOX8sKMqggfYLTTWb2xtDLthsFQoIkz+VkynfZoLa1A1I4dDD7+pwDryZVpoHeivA8/6KG4WP0AOblw+o68CHU36C0PJs/GhManzZZiQe5mSO+iJvBo8w3YvWdEbuzz629FZU2ktfRMgy+DBUO4KBr3yZ6xhIxH0taPb2br8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524270; c=relaxed/simple;
	bh=cgOPrA4mmtjOi2QuE5/uVnbeHAPCqHiwpu3pzlMClKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV73Y7HIAjgEk/IfbeV43Okh97KBkJVUrJ3DlEM7M3YStWJM28sUFe0lXk53esC3sPqVI+qNbJ/5Ni8NVamQYLsUiMpyzo5IYQ/ox7Rnatrpgukv5vJ6i904UmDftTmLIWoP/FH6drv1vCOPm1j6k0ZqRvN0Y5tZgfqkz3eGmZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIF+u78A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIF+u78A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C818C116B1;
	Mon, 18 Aug 2025 13:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524270;
	bh=cgOPrA4mmtjOi2QuE5/uVnbeHAPCqHiwpu3pzlMClKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIF+u78ANjHBalLX5mi8bBmHX9AVIxxBKpdAsri0Ufy85A5NyaInJ9sl7qDYiY3Zy
	 YwFJQQLkwtUulHNaIWtXiA7P+cmCgHCJmNnSEOlFn4hQRerdRiyAHDYXv/+VbJ7ND5
	 xnf6eBTZZegyxmG1GC/UaXF4sbSr8soXLhvzDBhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 420/515] tools/power turbostat: Handle cap_get_proc() ENOSYS
Date: Mon, 18 Aug 2025 14:46:46 +0200
Message-ID: <20250818124514.597344675@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <calvin@wbinvd.org>

[ Upstream commit d34fe509f5f76d9dc36291242d67c6528027ebbd ]

Kernels configured with CONFIG_MULTIUSER=n have no cap_get_proc().
Check for ENOSYS to recognize this case, and continue on to
attempt to access the requested MSRs (such as temperature).

Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 2c77ec8df67d..dd3c32ab9ec1 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -6527,8 +6527,16 @@ int check_for_cap_sys_rawio(void)
 	int ret = 0;
 
 	caps = cap_get_proc();
-	if (caps == NULL)
+	if (caps == NULL) {
+		/*
+		 * CONFIG_MULTIUSER=n kernels have no cap_get_proc()
+		 * Allow them to continue and attempt to access MSRs
+		 */
+		if (errno == ENOSYS)
+			return 0;
+
 		return 1;
+	}
 
 	if (cap_get_flag(caps, CAP_SYS_RAWIO, CAP_EFFECTIVE, &cap_flag_value)) {
 		ret = 1;
-- 
2.39.5



