Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459E61DD0DE;
	Tue, 15 Oct 2024 13:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998342; cv=none; b=GlstMpXQJ/95PvkfH7pkckdej1cMxqMO+z/nskDisgEBFutIavy0xfzZzyKape5q1cX8Jp9QAG+US9S7ZsNkn/f5yRj2CKj/Xc2MVdm0w/ScOcCEsP8PjIs+TTX3GABW+ouWl9Jol7pGtMDx9SeBM5sbkc9YjrkBndcyxcs7IBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998342; c=relaxed/simple;
	bh=UcYv6/rImnK8z4QJ7fnGslK3g92N4OqjLabKY5nBXqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSeVn7jJfh7jvqCm5XIXv5FJV71Uon5Pg06Y3f9WmxVbzPkKiM5e2lYDMN3yXOlufHlkuXsj7QHqFrEJq/iIdagbk9LN0F1szuW1cCwEFjoC9gH6rP3Pav1whHTB/stFeTpxcwMeJ2uK21SR09OSN4MmWfv3JV30FQFkKLI/77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qh9nw7Mv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qh9nw7Mv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FE1C4CEC6;
	Tue, 15 Oct 2024 13:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998341;
	bh=UcYv6/rImnK8z4QJ7fnGslK3g92N4OqjLabKY5nBXqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qh9nw7Mvs0awHAw17LkHXqA7gplL4Fid0Gsn1fnJhnz7v9DsPC8oijAz+rp7ZnSzL
	 9TKGZmvpvwiMUnajdn941UbjxQnv1WsHC321hK2UbCqABZvr1xBhc4lzo9AY8DHf3I
	 nCWaIoxaIadbYqcAfKU8IwDEcUmlcDTHeCTL+klY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 450/518] s390/facility: Disable compile time optimization for decompressor code
Date: Tue, 15 Oct 2024 14:45:54 +0200
Message-ID: <20241015123934.372794520@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 0147addc4fb72a39448b8873d8acdf3a0f29aa65 ]

Disable compile time optimizations of test_facility() for the
decompressor. The decompressor should not contain any optimized code
depending on the architecture level set the kernel image is compiled
for to avoid unexpected operation exceptions.

Add a __DECOMPRESSOR check to test_facility() to enforce that
facilities are always checked during runtime for the decompressor.

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/facility.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/facility.h b/arch/s390/include/asm/facility.h
index 68c476b20b57e..c7031d9ada293 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -53,8 +53,10 @@ static inline int test_facility(unsigned long nr)
 	unsigned long facilities_als[] = { FACILITIES_ALS };
 
 	if (__builtin_constant_p(nr) && nr < sizeof(facilities_als) * 8) {
-		if (__test_facility(nr, &facilities_als))
-			return 1;
+		if (__test_facility(nr, &facilities_als)) {
+			if (!__is_defined(__DECOMPRESSOR))
+				return 1;
+		}
 	}
 	return __test_facility(nr, &S390_lowcore.stfle_fac_list);
 }
-- 
2.43.0



