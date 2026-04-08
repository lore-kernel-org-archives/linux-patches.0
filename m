Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F37F324B1F;
	Wed,  8 Apr 2026 18:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672476; cv=none; b=dopAemVu5bFrxVNB28Y5MCuH2jP5AAY48ks8ZO1nMBVmdKUzlmhzcAE9Bz+zJ+mORvUFbwRvRh/3fnlxRg1nBKxBvadM3B7UrxK5bXz+6fabD6XBErfnE5Z7ntuomM2n8/9SlQw/TfKIiFTBMOzHMCdPbnzAL+IGObhyrOoZ9l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672476; c=relaxed/simple;
	bh=4ScQX4DkMIuZyaOiqblYXHAZP8yAX0Cdt/FTXzPJlCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsNLtyMkkx/khtjdfmUK/uI1OkuJhPxNYLWjXFo5VycM1dKSLNB1e1QnU6VgrlrhFNhbC7+qmHahvDQmkW2rYSTEzHF6o9bq+v8vmyt3y6Gxg7ZgNaI3IeXe5dyQelFHE6966PRSKl4F9miSrgW67ecvFnNc6EPtKt6psclka0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCvO45mi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCvO45mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5300DC19421;
	Wed,  8 Apr 2026 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672475;
	bh=4ScQX4DkMIuZyaOiqblYXHAZP8yAX0Cdt/FTXzPJlCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCvO45miI3RVRhEORjvGKb7Sm8L5KWXAXxwntu/7nQR9I4PxXJj5hdlErvxa7NZfM
	 Z978p231am61yj3s/kknWqJUdXMywq74OA7KDCDIkJHMu8pfM7vCuOhunr/XWT5ph/
	 5nQOXW4r7lUEcVe0bFvgTTmrgzFLsGZg07w98coc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Justin Iurman <justin.iurman@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/160] net/ipv6: ioam6: prevent schema length wraparound in trace fill
Date: Wed,  8 Apr 2026 20:01:48 +0200
Message-ID: <20260408175913.989475091@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5e67ba9bb531e1ec6599a82a065dea9040b9ce50 ]

ioam6_fill_trace_data() stores the schema contribution to the trace
length in a u8. With bit 22 enabled and the largest schema payload,
sclen becomes 1 + 1020 / 4, wraps from 256 to 0, and bypasses the
remaining-space check. __ioam6_fill_trace_data() then positions the
write cursor without reserving the schema area but still copies the
4-byte schema header and the full schema payload, overrunning the trace
buffer.

Keep sclen in an unsigned int so the remaining-space check and the write
cursor calculation both see the full schema length.

Fixes: 8c6f6fa67726 ("ipv6: ioam: IOAM Generic Netlink API")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index a35b6fdbc93e9..a1953cf6131be 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -648,7 +648,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 				    struct ioam6_namespace *ns,
 				    struct ioam6_trace_hdr *trace,
 				    struct ioam6_schema *sc,
-				    u8 sclen, bool is_input)
+				    unsigned int sclen, bool is_input)
 {
 	struct timespec64 ts;
 	ktime_t tstamp;
@@ -878,7 +878,7 @@ void ioam6_fill_trace_data(struct sk_buff *skb,
 			   bool is_input)
 {
 	struct ioam6_schema *sc;
-	u8 sclen = 0;
+	unsigned int sclen = 0;
 
 	/* Skip if Overflow flag is set
 	 */
-- 
2.53.0



