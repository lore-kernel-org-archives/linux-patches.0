Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908C33612FF;
	Tue, 16 Dec 2025 12:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886896; cv=none; b=JpEzmky0+E7d4JRf8VBG3h/EgUuyGhQ/R2hf+/y9qy3O8hNVfwyGpThMoiBvVFN2/kiow/uv++JU0dwByqXNSA/j2O+qlwNLu02Qv2vd9hYiNWH7mZ5OMyhy5I/ml8bPWukAldubxcQvSZIt19w3Ou5qtYLLB3LTD2GFLbiQ19A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886896; c=relaxed/simple;
	bh=Ij74Q6hDcYJUK6dLOoWp2ngOhwqraRfHAr5mLGFMmOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYnvd1+sbNcbYFHVuwj5UOXroWeDCm4+sSkV0B36YCyNhgBxR1vAKN+EpX/m3kkZck/vzUxAqRzNxiPi5CnlpayMpJiOOvzYaO2DnqVb369nJJA+BLFdEreEs3A7Y0QYKyjHaiMMfibjfniw6t/xG3b19Jqsj+dZoGi+qnrzc2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZXSQ8Hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZXSQ8Hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5B3C4CEF1;
	Tue, 16 Dec 2025 12:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886896;
	bh=Ij74Q6hDcYJUK6dLOoWp2ngOhwqraRfHAr5mLGFMmOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZXSQ8HpnHe4PtHYAV36SwrVlWiDCpQbLt3IPyMOYgonKCACPfvt7A1NeAaRzjdfa
	 q/Lr76ViqqzfDEAVMk3LdfMWjdYE84TrJdJ0IbwK9xGAQPl32hH2VddOkFapTmnykD
	 yoNrQtIQ9fyQF1SR8xNVpl5zK+5kiGR7euMpTf1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Hatch <dylanbhatch@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/614] objtool: Fix standalone --hacks=jump_label
Date: Tue, 16 Dec 2025 12:06:40 +0100
Message-ID: <20251216111402.508827536@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Hatch <dylanbhatch@google.com>

[ Upstream commit be8374a5ba7cbab6b97df94b4ffe0b92f5c8a6d2 ]

The objtool command line 'objtool --hacks=jump_label foo.o' on its own
should be expected to rewrite jump labels to NOPs. This means the
add_special_section_alts() code path needs to run when only this option
is provided.

This is mainly relevant in certain debugging situations, but could
potentially also fix kernel builds in which objtool is run with
--hacks=jump_label but without --orc, --stackval, --uaccess, or
--hacks=noinstr.

Fixes: de6fbcedf5ab ("objtool: Read special sections with alts only when specific options are selected")
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 9004fbc067693..6059a546fb759 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2564,7 +2564,8 @@ static int decode_sections(struct objtool_file *file)
 	 * Must be before add_jump_destinations(), which depends on 'func'
 	 * being set for alternatives, to enable proper sibling call detection.
 	 */
-	if (opts.stackval || opts.orc || opts.uaccess || opts.noinstr) {
+	if (opts.stackval || opts.orc || opts.uaccess || opts.noinstr ||
+	    opts.hack_jump_label) {
 		ret = add_special_section_alts(file);
 		if (ret)
 			return ret;
-- 
2.51.0



