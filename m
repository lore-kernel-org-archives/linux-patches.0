Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5174E9460;
	Mon, 29 Dec 2025 16:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025358; cv=none; b=MERVkdOzAmGPqokdsFcHZv7w7HsP9AL+53vvq2/bCgW3++c2KBzTj4rzst1b8mnioJ0nN9F1HRQ5v7f7nr8TVqOmS0O1vrR6qWFa3oye5eN7Yyk6qwMd5iQ7PzauSQVv7HEQe+NnjQdzGzTViPfM1tIQGIdsUg95xEO6sdiQ72I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025358; c=relaxed/simple;
	bh=7CKROYoCKAEDpMMdgdShnowNb+HEyfOKiZtHtWjzeVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIYqNXO/VeoAvoHV7gILnCb9ZurXmkqRhHCgbdobVop3zzHaDF+LjtQko4740Q4qOuSSXvMTAJ9iXXQNNzL6FgwcDx+UAER5c5iuD8RWZrv0UfiFdQYN7GiTQSCrnJasvFEj0ww+Cy5Sg8xSRjuN0Qft9uqshGvjUpPGpsFhEtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iszJgovn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iszJgovn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB2BC4CEF7;
	Mon, 29 Dec 2025 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025358;
	bh=7CKROYoCKAEDpMMdgdShnowNb+HEyfOKiZtHtWjzeVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iszJgovnRFfQv2gGQxfBH3+wmdogHPdlko8pgr5I0HhNzlbfAn6gBiYZqyAVIn0e1
	 0rNboq5LPPXyuAbetEunLTco8o4YNPfOt59Uz8HRRC0q66qzdAUFrykautJqHacBU/
	 msM2zFdEAHNTAUz/MinFd/DoCLM7jMZHM8EGTUA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Collins <bcollins@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 185/430] powerpc/addnote: Fix overflow on 32-bit builds
Date: Mon, 29 Dec 2025 17:09:47 +0100
Message-ID: <20251229160731.165937355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Ben Collins <bcollins@kernel.org>

[ Upstream commit 825ce89a3ef17f84cf2c0eacfa6b8dc9fd11d13f ]

The PUT_64[LB]E() macros need to cast the value to unsigned long long
like the GET_64[LB]E() macros. Caused lots of warnings when compiled
on 32-bit, and clobbered addresses (36-bit P4080).

Signed-off-by: Ben Collins <bcollins@kernel.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/2025042122-mustard-wrasse-694572@boujee-and-buff
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/addnote.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/boot/addnote.c b/arch/powerpc/boot/addnote.c
index 53b3b2621457..78704927453a 100644
--- a/arch/powerpc/boot/addnote.c
+++ b/arch/powerpc/boot/addnote.c
@@ -68,8 +68,8 @@ static int e_class = ELFCLASS32;
 #define PUT_16BE(off, v)(buf[off] = ((v) >> 8) & 0xff, \
 			 buf[(off) + 1] = (v) & 0xff)
 #define PUT_32BE(off, v)(PUT_16BE((off), (v) >> 16L), PUT_16BE((off) + 2, (v)))
-#define PUT_64BE(off, v)((PUT_32BE((off), (v) >> 32L), \
-			  PUT_32BE((off) + 4, (v))))
+#define PUT_64BE(off, v)((PUT_32BE((off), (unsigned long long)(v) >> 32L), \
+			  PUT_32BE((off) + 4, (unsigned long long)(v))))
 
 #define GET_16LE(off)	((buf[off]) + (buf[(off)+1] << 8))
 #define GET_32LE(off)	(GET_16LE(off) + (GET_16LE((off)+2U) << 16U))
@@ -78,7 +78,8 @@ static int e_class = ELFCLASS32;
 #define PUT_16LE(off, v) (buf[off] = (v) & 0xff, \
 			  buf[(off) + 1] = ((v) >> 8) & 0xff)
 #define PUT_32LE(off, v) (PUT_16LE((off), (v)), PUT_16LE((off) + 2, (v) >> 16L))
-#define PUT_64LE(off, v) (PUT_32LE((off), (v)), PUT_32LE((off) + 4, (v) >> 32L))
+#define PUT_64LE(off, v) (PUT_32LE((off), (unsigned long long)(v)), \
+			  PUT_32LE((off) + 4, (unsigned long long)(v) >> 32L))
 
 #define GET_16(off)	(e_data == ELFDATA2MSB ? GET_16BE(off) : GET_16LE(off))
 #define GET_32(off)	(e_data == ELFDATA2MSB ? GET_32BE(off) : GET_32LE(off))
-- 
2.51.0



