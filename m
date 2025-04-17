Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410FF1DF756;
	Thu, 17 Apr 2025 18:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913331; cv=none; b=QzAKmrer5bes037Qlfb/+BiMx0nBClYLtd0OnI87hunp2Yb2TjvvIStsNcg6o4vQ6yKSI7TTx9y7ZyNDlyXOJHc3xw9y8QyZ3YQ5zIn9N4Vcxra61C1uVWZG0d7w3CtdEawWFB/BXKnuoy+lK96Tl6XnU+ftOLXh5RywTX6/c5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913331; c=relaxed/simple;
	bh=5MpKETK9BltOfOXz8L5OVv2chD9Enulz1AZsbml4LJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldW6nN5CtLkN3ZYBqb8/EzSqjXwjcDJUofjk2MmMHqpgvUnXJ/dXBTbuD2hqHUT//T9vPNv0EunSmqbUOMMPqHkvi6oDtcmyopGddiNVAqn5m82TcG+qlh6ahnDmW/L2xgHbfXHI4r1pgW3LMi/JKiuVTnusmYsrEqg9mFe0j5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVByaHnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVByaHnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAABC4CEE4;
	Thu, 17 Apr 2025 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913331;
	bh=5MpKETK9BltOfOXz8L5OVv2chD9Enulz1AZsbml4LJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVByaHnWay2fPvUal7EL3q0jPvhavtDAzvfs6fFTMijQXuMUncwZVzRnnHgIKQxq7
	 hC2WPpulGwvyz25B5h5QWzWvhyrPHZJQQIld3RumpeAZRUC4JcimrErJSBmGmo9kjt
	 Y2h5U+IadrtyMuG5ferpTQkY5rnbjsnKTEhJsglE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Binderman <dcb314@hotmail.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 6.14 304/449] arm64/crc-t10dif: fix use of out-of-scope array in crc_t10dif_arch()
Date: Thu, 17 Apr 2025 19:49:52 +0200
Message-ID: <20250417175130.337401876@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit d48b663f410f8b35b8ba9bd597bafaa00f53293b upstream.

Fix a silly bug where an array was used outside of its scope.

Fixes: 2051da858534 ("arm64/crc-t10dif: expose CRC-T10DIF function through lib")
Cc: stable@vger.kernel.org
Reported-by: David Binderman <dcb314@hotmail.com>
Closes: https://lore.kernel.org/r/AS8PR02MB102170568EAE7FFDF93C8D1ED9CA62@AS8PR02MB10217.eurprd02.prod.outlook.com
Link: https://lore.kernel.org/r/20250326200918.125743-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/lib/crc-t10dif-glue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/lib/crc-t10dif-glue.c b/arch/arm64/lib/crc-t10dif-glue.c
index a007d0c5f3fe..bacd18f23168 100644
--- a/arch/arm64/lib/crc-t10dif-glue.c
+++ b/arch/arm64/lib/crc-t10dif-glue.c
@@ -45,9 +45,7 @@ u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
 			crc_t10dif_pmull_p8(crc, data, length, buf);
 			kernel_neon_end();
 
-			crc = 0;
-			data = buf;
-			length = sizeof(buf);
+			return crc_t10dif_generic(0, buf, sizeof(buf));
 		}
 	}
 	return crc_t10dif_generic(crc, data, length);
-- 
2.49.0



