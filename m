Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060821;
	b=0o9lYLdeeKWCYCikgqPFWyA35yVsd0jAdu9CTQqpGE3nIO8/Cbw9c+JAwuUk0VCXG5Ar
	 OpoCKNw7bd/mha6HDm4EZ74Yj/IFTdeLuiSAM8SxlSUHlfjPbLvnQo2lbaY/06kCXouvJ
	 w1Zbg3YX4wyfIzD47NHqlf6VOeWl7QvQySU/ShVyhYDsLg4HmFiT0HOz16+H5c6Mv0r4S
	 43wfpntxRdJPAt73ozl523Uyt1pJvItKnFLfvG7NtV5feo69GFzU6lNwQ2NfFbCZ+x8CA
	 jSMY5lWD6GG82+Om0WVq8MvtH80Grr6AlQW7rCp1pd1o8FcDjc4LJwqAYgJg9DD8xmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=47IP3164yjGWYNO71Af7SFd4usslLiGbcDH6abhrQfw=;
	b=d2nbTWf5v1QImoiPPNjtOTh2FkqrRb9Mxslbs/RXUrf26il3uaiXKsHy7WaPzRA9Ar1r
	 SCSDN7SGJQCzyauz7Tmk0uyIweS0su+ZzOLYC1j3Zvm/LMOZLHp/yg9LM/if09boCdbIZ
	 DpXdtdRsFNqmHdYkbTYCLm/tmqsjmu22H6xg5WsHMloQW/4APr1bDmfUK+Qu0KVODPttG
	 dK55ZsHMOuXfcXE21Jsnf8QD7UrxQyoD1eUD9YlmsdrbnbKfm5vy65MUr2Wu7r7kPMLPt
	 2s+rPNzdzn+pLjjAEwyz9Oy5Ny82IgXLpTrhdv5zuOqLYBlPIDzIcdOWIH36HgpUaOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDfBIK2V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A39606A326;
	Sat,  7 Nov 2026 14:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDfBIK2V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57101F0089F;
	Sat,  7 Nov 2026 14:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060820;
	bh=47IP3164yjGWYNO71Af7SFd4usslLiGbcDH6abhrQfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDfBIK2Vz7AuOkZNSzfKjA48hhYqRV4YJmnL8PiPKmQzVud8x1DBPbMtwtz8DK+Pr
	 6xwcRxtQDnB0omskBiPm/Qiowwu/SaeGFQsGnEgzWwXgJS/sbEokD7xZBUzi95CAua
	 DhoEo5o4H52gN4xmd2h8qAAfCP7okv635X3I7Z4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0218/1536] udf: Fix bh leak for unallocated space entries
Date: Sat,  7 Nov 2026 08:37:14 -0500
Message-ID: <20261107135003.783294433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cc4fe471b325a..05eddd60e80a7 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1488,6 +1488,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct unallocSpaceEntry),
 		       bs - sizeof(struct unallocSpaceEntry));
+		brelse(bh);
 		return 0;
 	}
 
-- 
2.53.0



