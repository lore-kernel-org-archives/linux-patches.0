Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057413;
	b=qug79XPbJZ5SXtNjEJMmwEPrincsW+2l1JqjHBuNwL8Kl5o+unr/O4ibggtYMdrzBBsW
	 7hcoDTFjGIHRVdymp2GadrzmNvzQ6Jx4M6y4Xo8f1ZFGeFjKIianY1TuBBKasYDq/9wqe
	 qiuPZfi/x1XybW+rwL7xwldLRG7ZXgzRpVd5Wu+ki3YWo+jmkD0nvy/7U27P6pxSjI92D
	 PO79HjgClSWC8BhcxGpcgLGgSZgMyrPSjwqeihmBY6ZxQkqBLa9sLGwpX0L4PzrYqu+Se
	 WhMAF4jrArzlK9DwBOm/jEXyssu2m995yEjsnqHG/POhoj+BvuWTiljLGjh/jHLV5vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o/bW8pfK1Ssx1IkjlfqEUH5k0E1Ee1nONfMpkfTrJkA=;
	b=oa85kvn5DBpyW5nxRJD84mZFLVSclxFIz5ejyhtcZMvQXqgu/TxevFVcaTz/91FeppTq
	 SDOUsDYcLtVfBvVGUkHCSh1zxTPuLPqKCZPxvrwnYAmf89wA6qby7nuAey1xeDdxANI1a
	 d26FGnyF7GmWCUJoLg5EhZX8rFJtHrwHveiC5vkZLgRTmdXnLEQuzD8PS0VJj95rQDJB5
	 WDSJzhU0EAjmeslKkZBeVZcFhbgJotXplp92mQc892ElKzrQ9+AC8SiIsORJ7Wx8ZUwXF
	 eMVV0A6aopK9myLaSigeMQIULH4VHwZxwGPSBvkAT1VLeYuYs/re5QfS01MtkT42j4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6qolygD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CF6606A332;
	Thu, 19 Nov 2026 03:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6qolygD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E451F000C4;
	Thu, 19 Nov 2026 03:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057413;
	bh=o/bW8pfK1Ssx1IkjlfqEUH5k0E1Ee1nONfMpkfTrJkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6qolygDp2m5vqfkJB2Q1IQYfPBCdlJrNsofx/7gAWVNwtvKUxVb4+Z+cPzCcjF2/
	 uxqh1xxlSJ7KcCyYhLvKyJMOFXg61P05bbVpsck1c0ny+dN82KE8SehoRiACH4Pj+w
	 RQ6DJ3dw/C0qNjoL75RTAshI8I7OQpxKUQTMz8K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0122/1848] udf: Fix bh leak for unallocated space entries
Date: Wed, 18 Nov 2026 15:36:00 +0100
Message-ID: <20261118145916.054719431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit d95094d4c0a62ea17b8a7c6399b42381b8a55bc0 ]

When processing unallocated space entries we didn't properly release the
inode bh. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 930b17317c1ac..6afbc17af652b 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1432,6 +1432,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct unallocSpaceEntry),
 		       bs - sizeof(struct unallocSpaceEntry));
+		brelse(bh);
 		return 0;
 	}
 
-- 
2.53.0



