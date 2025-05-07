Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3707C2144C1;
	Wed,  7 May 2025 19:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645022; cv=none; b=Sb/LnaiFVmQU3zcQ79yv5/irNnrxBQAhv+kFciDJbj/FcdyHA9EJGLHeqTJYQgJabOKqLor9FWEQvJdA/W4EvCWPE+3mA4PmYq2Dr9efO26VSp8SuWzwxTHqCRd3a8jpFjzqGRyFVeFYLK1Y5Px142klpgmT8A+iVuod0tPTrQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645022; c=relaxed/simple;
	bh=/y1i7yewZkHk/KyZnZl3kaA8la84BNf1BAPuec+0/LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2ALJTYw3aEEfjxNOp/ZoCsnBP482p4Yf3YWCIqf3p5LM7ra7sq6jDRt0KzRSGYCWSRlBTlKnBXBrwUhGOIRpnCz8KzA70DzBW9/lGxhRWdrFSq+ouZGXpnJgJnxDC3J09O/gTFBu6MKXyrwQ6a6BMmJm3yvAAZowy2kpIyqfKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snFonUBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snFonUBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE96DC4CEE2;
	Wed,  7 May 2025 19:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645022;
	bh=/y1i7yewZkHk/KyZnZl3kaA8la84BNf1BAPuec+0/LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snFonUBXBkXwyRhVTe5UE5wnVuOmaZpbSXBV+t13kEA7RX8OBFiUTwF+7+GNVHauD
	 eD1g9GyBi/0/yvki7rvRPgczT6sJZzfxselvS6SnaugCV1k/h3swhbUanOufGelIbo
	 gXR8IrcQz0fH1ogK3Q2Qeh2hrHb9hRunkaupGvX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/129] powerpc/boot: Fix dash warning
Date: Wed,  7 May 2025 20:39:48 +0200
Message-ID: <20250507183815.645458260@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit e3f506b78d921e48a00d005bea5c45ec36a99240 ]

'commit b2accfe7ca5b ("powerpc/boot: Check for ld-option support")' suppressed
linker warnings, but the expressed used did not go well with POSIX shell (dash)
resulting with this warning

arch/powerpc/boot/wrapper: 237: [: 0: unexpected operator
ld: warning: arch/powerpc/boot/zImage.epapr has a LOAD segment with RWX permissions

Fix the check to handle the reported warning. Patch also fixes
couple of shellcheck reported errors for the same line.

In arch/powerpc/boot/wrapper line 237:
if [ $(${CROSS}ld -v --no-warn-rwx-segments &>/dev/null; echo $?) -eq 0 ]; then
     ^-- SC2046 (warning): Quote this to prevent word splitting.
       ^------^ SC2086 (info): Double quote to prevent globbing and word splitting.
                                            ^---------^ SC3020 (warning): In POSIX sh, &> is undefined.

Fixes: b2accfe7ca5b ("powerpc/boot: Check for ld-option support")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250423082154.30625-1-maddy@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/wrapper | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index fea9694f1047e..ddb02cf0caaf5 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -234,7 +234,7 @@ fi
 
 # suppress some warnings in recent ld versions
 nowarn="-z noexecstack"
-if [ $(${CROSS}ld -v --no-warn-rwx-segments &>/dev/null; echo $?) -eq 0 ]; then
+if "${CROSS}ld" -v --no-warn-rwx-segments >/dev/null 2>&1; then
 	nowarn="$nowarn --no-warn-rwx-segments"
 fi
 
-- 
2.39.5



