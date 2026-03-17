Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5C73624BF;
	Tue, 17 Mar 2026 17:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768123; cv=none; b=ti4vxy0ntoqcCVQHPiMmFPZuE6vVRwDSCJFMRTjrBrXyALyxv0A0zcOr9S2DYAv2ZrKqsQ4XwF+3rbNC+q1DMyZWfYvlH1opHv7oCsBJEiAwTYUOsVDZLwzU5lvFgo6nMhNJYqp+J59knsZkFE2J06gHW/XCfYtPDajjUbc0bBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768123; c=relaxed/simple;
	bh=rpT3GtyKyCLhy8bs6n1AP7BvE/KhPX3TKplIl/KK59w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYBXIyYqT6+kcMqP5MV3Bv8hkPpxKe3nWebSDUdbAh8HeoVHJx5UDfPk3mM+k+bQsc01TtSqnP354AW3+1DWglbbSTO67/fcO0UTTM3JJjAqeMJP8SWsydP3pg/yRlmDESUpSA9H//ox6gcWSlkzmCVVDmhSFx/ioFfWW4ZQyPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIQg8uYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIQg8uYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5402CC19424;
	Tue, 17 Mar 2026 17:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768122;
	bh=rpT3GtyKyCLhy8bs6n1AP7BvE/KhPX3TKplIl/KK59w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIQg8uYjjwwvICDoLhd5LxdWEzvpjnkQkuAvBSCeNTPGRFmN/4+WrVyZPxmalyqSo
	 fxI8io70isegrDGaopErGxGJjzhD9ah6GqBEDUhKXn8AqDJ5vR2Tzy5f5hhkb+VFWs
	 /NbW951qGL6H5XWfp75oHcHY0aIYlOSq8pV0PujA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 235/333] s390/stackleak: Fix __stackleak_poison() inline assembly constraint
Date: Tue, 17 Mar 2026 17:34:24 +0100
Message-ID: <20260317163008.079626426@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

commit 674c5ff0f440a051ebf299d29a4c013133d81a65 upstream.

The __stackleak_poison() inline assembly comes with a "count" operand where
the "d" constraint is used. "count" is used with the exrl instruction and
"d" means that the compiler may allocate any register from 0 to 15.

If the compiler would allocate register 0 then the exrl instruction would
not or the value of "count" into the executed instruction - resulting in a
stackframe which is only partially poisoned.

Use the correct "a" constraint, which excludes register 0 from register
allocation.

Fixes: 2a405f6bb3a5 ("s390/stackleak: provide fast __stackleak_poison() implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20260302133500.1560531-4-hca@linux.ibm.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -164,7 +164,7 @@ static __always_inline void __stackleak_
 		"	j	4f\n"
 		"3:	mvc	8(1,%[addr]),0(%[addr])\n"
 		"4:"
-		: [addr] "+&a" (erase_low), [count] "+&d" (count), [tmp] "=&a" (tmp)
+		: [addr] "+&a" (erase_low), [count] "+&a" (count), [tmp] "=&a" (tmp)
 		: [poison] "d" (poison)
 		: "memory", "cc"
 		);


