Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5686B2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D3FC433EF;
	Sun, 22 Jan 2023 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401198;
	bh=iNdAV+vBRrMqio/Q3dqnZqd2JoJKIzv6BoqM19+2NCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/g7GKGOKd5BHpoWVIbvK3zAy/xrkBHwWvwhA7yS4dgPSkvfpn6oF0ge8LDo5Dsip
	 0lSa6cs5Ru+KfpUwsR/QL2fg2UHJ5thUXY0PyLnxNpG3n0sBLxY+XtlqmpABHjW6c0
	 9GRILtVDKJAzAhzmzgwDPvVSgiahEfEbE8FW6f3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alon Zahavi <zahavi.alon@gmail.com>,
	Tal Lossos <tallossos@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 147/193] fs/ntfs3: Fix attr_punch_hole() null pointer derenference
Date: Sun, 22 Jan 2023 16:04:36 +0100
Message-Id: <20230122150253.102715750@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alon Zahavi <zahavi.alon@gmail.com>

commit 6d5c9e79b726cc473d40e9cb60976dbe8e669624 upstream.

The bug occours due to a misuse of `attr` variable instead of `attr_b`.
`attr` is being initialized as NULL, then being derenfernced
as `attr->res.data_size`.

This bug causes a crash of the ntfs3 driver itself,
If compiled directly to the kernel, it crashes the whole system.

Signed-off-by: Alon Zahavi <zahavi.alon@gmail.com>
Co-developed-by: Tal Lossos <tallossos@gmail.com>
Signed-off-by: Tal Lossos <tallossos@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/attrib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -2038,7 +2038,7 @@ int attr_punch_hole(struct ntfs_inode *n
 		return -ENOENT;
 
 	if (!attr_b->non_res) {
-		u32 data_size = le32_to_cpu(attr->res.data_size);
+		u32 data_size = le32_to_cpu(attr_b->res.data_size);
 		u32 from, to;
 
 		if (vbo > data_size)


