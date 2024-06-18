Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E3513C806;
	Tue, 18 Jun 2024 13:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716246; cv=none; b=aZ89o6ZKnx3/tDF6RS0EXFW4Sfc5mq88YZ5rNGd58UxByvSax/JXQeAFbac/POClP4HGu3NLjV6Pq/LlLx4RE0Y/jZgPTiT+BX4WibiuWXfrhsyF9Ka7O0evs0Am4qUSpah1Rdzx2SHecUo9Csx/SJ0xMbtasjokbmdDQQo5pyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716246; c=relaxed/simple;
	bh=7StlJ3Gn7yCtplmVUTTPRM4ee5JYSQNMPqWc3SmyGK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWrHefsJeOXHSjTNRESev7vFWQ/MzKw3L1xKYJ1Od1mXfIi/LLeRW3CNeYzcqvdlG3nEPVdsJy7bs+HKB810Pp5Tj/bc5gvy35DpBkHURDW3z89vyFZL+xabJB2qHPxChtkpTn0UxFexZujC83z4iPdI53dK1/PvFzVLmk71RYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVH49NZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVH49NZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3F6C3277B;
	Tue, 18 Jun 2024 13:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716246;
	bh=7StlJ3Gn7yCtplmVUTTPRM4ee5JYSQNMPqWc3SmyGK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVH49NZvKUXhKaU2+LqNLsefBVm+aOzNkSUeEwrt6cIzUdryWvyn3kvNKzyvbtO1N
	 WXJuslCNhda3bRLzdFhOuTdGnk1MuQzX95VsBdw8kMhH/Mv0jU9E2DKnUFTM+wm4wX
	 9CRFwXAZD9SHJN2sTxHq05YaQLP7AhqR2LqK8/PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 550/770] SUNRPC: Fix xdr_encode_bool()
Date: Tue, 18 Jun 2024 14:36:43 +0200
Message-ID: <20240618123428.535484685@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c770f31d8f580ed4b965c64f924ec1cc50e41734 ]

I discovered that xdr_encode_bool() was returning the same address
that was passed in the @p parameter. The documenting comment states
that the intent is to return the address of the next buffer
location, just like the other "xdr_encode_*" helpers.

The result was the encoded results of NFSv3 PATHCONF operations were
not formed correctly.

Fixes: ded04a587f6c ("NFSD: Update the NFSv3 PATHCONF3res encoder to use struct xdr_stream")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xdr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index b8fb866e1fd32..59d99ff31c1a9 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -418,8 +418,8 @@ static inline int xdr_stream_encode_item_absent(struct xdr_stream *xdr)
  */
 static inline __be32 *xdr_encode_bool(__be32 *p, u32 n)
 {
-	*p = n ? xdr_one : xdr_zero;
-	return p++;
+	*p++ = n ? xdr_one : xdr_zero;
+	return p;
 }
 
 /**
-- 
2.43.0



