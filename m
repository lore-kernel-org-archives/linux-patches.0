Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828BB288A8;
	Wed,  7 May 2025 19:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644593; cv=none; b=u40fcXW2LGnRgBm5jd76N/KmI2/JHA25b2tVpIDblGn2Exr8v7wIgm5UNV6SvQIVFvhnniwUdDByqYvwRleLhXCUqXHvzndz5w/5VqN2adkdEYI+8ZH6v8zGsoD+Rku0HihYE8t7LlvoYBz+WK3uK7G0imq7TCmpQK/A7/zyGCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644593; c=relaxed/simple;
	bh=jBTq5a5MrUDAd7lM8tH6+eDRFw9p6Qbf8i4CFauZIB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzGhGDC/Q6/fmDjCtaMij7OVgK2sxXJiHMBmJkkg0cAD+Q5j0gZn5jQCwb1LgOn8WMyV6VFmdVjeY334h/NEhuL4oXcA7EyGA2Dv/MAhym5p7J9nJdLQ6QKqwlH3Cc4d+R0uhr8mWGDGF1UgDRNWXoRTJLgnbV9ivweF2T9O1Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PoN4H24N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PoN4H24N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E3DC4CEE2;
	Wed,  7 May 2025 19:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644593;
	bh=jBTq5a5MrUDAd7lM8tH6+eDRFw9p6Qbf8i4CFauZIB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PoN4H24NUI4VkpKW6pBVk+78k+KVI5q7d5rct92YX0o/xkG8/iiiq8+ITplVK0FHS
	 D9/+nx/L1EPnbqSaDlRyuEkvsPSkLo6/h91FCER09IL/kEYYiEOiHs6Jww3P+v8VBw
	 9x57RDX/Uj7rTiMjgHRHQ6Nkkejy88PXfROotTc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/164] powerpc/boot: Fix dash warning
Date: Wed,  7 May 2025 20:39:09 +0200
Message-ID: <20250507183823.541888681@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 08f7a1386e8e0..fd6db10ef9e65 100755
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



