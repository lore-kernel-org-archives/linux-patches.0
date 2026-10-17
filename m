Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC703845B3;
	Sat, 17 Oct 2026 16:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253627; cv=none; b=WJmp9stPf7ShyZp76nt8JeCR6KsYuSjCfemOVZIRNbX63WOZ06UYmxpC99F2XgTsCF0s/Ost/GF3uC5hK160w1KGCDPbTi46t99tvUgj7cUgniX7lXqPcQMMHdWpyStrdVPgbbaehuqm39o0K2ZANcY54LB/fGnjan0jo4RIyIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253627; c=relaxed/simple;
	bh=2WNSrTlz0n0R0uYpcB7DYKwKyGYqD7Xo7eG8g3rAj/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRi+U3hIFwyt94hi7jGjHzn6/nE4hn2iB/zSMpjbizYkSx2sZo5Uv7UMKv5OIpLOhyC4gbFyO2Z3IHSrOkFokaySXkXFwomb+tn8qmcJdv+or5/nnT4pZWH6nvlb4VQgxYEn2yhmS3XpQyK2+dxKC1eSm3A/aTLQe9JboZtsy7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eA+i9iv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eA+i9iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2379A1F000C6;
	Sat, 17 Oct 2026 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253622;
	bh=AqrSPh9g+yXWTCO/7PNQzspQQdVVLW5jj82U3YHw5XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2eA+i9ivnDTCu6GOxS82d5NcmJQvQ3Isl1HCW1Si4zbIcLXUFxsvlOtLKPK7r85IA
	 hdol8xW+OaFBdo1IKyZgQC9Q6nJiZo8y3RtoVaVKMVl6S/CzetptmevMwdaCiadljE
	 Q5kVKJcLuxUSn1Ud/A8oUGyLt+CSWFpluqB0NXrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/869] virtio_net: Fix misalignment bug in struct virtnet_info
Date: Sat, 17 Oct 2026 17:50:20 +0200
Message-ID: <20261017160041.641833855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 4156c3745f06bc197094b9ee97a9584e69ed00bf ]

Use the new TRAILING_OVERLAP() helper to fix a misalignment bug
along with the following warning:

drivers/net/virtio_net.c:429:46: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

This helper creates a union between a flexible-array member (FAM)
and a set of members that would otherwise follow it (in this case
`u8 rss_hash_key_data[VIRTIO_NET_RSS_MAX_KEY_SIZE];`). This
overlays the trailing members (rss_hash_key_data) onto the FAM
(hash_key_data) while keeping the FAM and the start of MEMBERS aligned.
The static_assert() ensures this alignment remains.

Notice that due to tail padding in flexible `struct
virtio_net_rss_config_trailer`, `rss_trailer.hash_key_data`
(at offset 83 in struct virtnet_info) and `rss_hash_key_data` (at
offset 84 in struct virtnet_info) are misaligned by one byte. See
below:

struct virtio_net_rss_config_trailer {
        __le16                     max_tx_vq;            /*     0     2 */
        __u8                       hash_key_length;      /*     2     1 */
        __u8                       hash_key_data[];      /*     3     0 */

        /* size: 4, cachelines: 1, members: 3 */
        /* padding: 1 */
        /* last cacheline: 4 bytes */
};

struct virtnet_info {
...
        struct virtio_net_rss_config_trailer rss_trailer; /*    80     4 */

        /* XXX last struct has 1 byte of padding */

        u8                         rss_hash_key_data[40]; /*    84    40 */
...
        /* size: 832, cachelines: 13, members: 48 */
        /* sum members: 801, holes: 8, sum holes: 31 */
        /* paddings: 2, sum paddings: 5 */
};

After changes, those members are correctly aligned at offset 795:

struct virtnet_info {
...
        union {
                struct virtio_net_rss_config_trailer rss_trailer; /*   792     4 */
                struct {
                        unsigned char __offset_to_hash_key_data[3]; /*   792     3 */
                        u8         rss_hash_key_data[40]; /*   795    40 */
                };                                       /*   792    43 */
        };                                               /*   792    44 */
...
        /* size: 840, cachelines: 14, members: 47 */
        /* sum members: 801, holes: 8, sum holes: 35 */
        /* padding: 4 */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 8 bytes */
};

As a result, the RSS key passed to the device is shifted by 1
byte: the last byte is cut off, and instead a (possibly
uninitialized) byte is added at the beginning.

As a last note `struct virtio_net_rss_config_hdr *rss_hdr;` is also
moved to the end, since it seems those three members should stick
around together. :)

Cc: stable@vger.kernel.org
Fixes: ed3100e90d0d ("virtio_net: Use new RSS config structs")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/aWIItWq5dV9XTTCJ@kspp
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index cb640d29d7912..851defa105e04 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -409,9 +409,6 @@ struct virtnet_info {
 	u16 rss_indir_table_size;
 	u32 rss_hash_types_supported;
 	u32 rss_hash_types_saved;
-	struct virtio_net_rss_config_hdr *rss_hdr;
-	struct virtio_net_rss_config_trailer rss_trailer;
-	u8 rss_hash_key_data[VIRTIO_NET_RSS_MAX_KEY_SIZE];
 
 	/* Has control virtqueue */
 	bool has_cvq;
@@ -470,7 +467,16 @@ struct virtnet_info {
 	struct failover *failover;
 
 	u64 device_stats_cap;
+
+	struct virtio_net_rss_config_hdr *rss_hdr;
+
+	/* Must be last as it ends in a flexible-array member. */
+	TRAILING_OVERLAP(struct virtio_net_rss_config_trailer, rss_trailer, hash_key_data,
+		u8 rss_hash_key_data[VIRTIO_NET_RSS_MAX_KEY_SIZE];
+	);
 };
+static_assert(offsetof(struct virtnet_info, rss_trailer.hash_key_data) ==
+	      offsetof(struct virtnet_info, rss_hash_key_data));
 
 struct padded_vnet_hdr {
 	struct virtio_net_hdr_v1_hash hdr;
-- 
2.53.0



