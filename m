Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626018;
	b=I+Z7Y9cuPIJdXyvDjMiXFzMRzxp8VXvG5pqpuTZS746Dtzkm8I51osgQn83MQs6z7BIi
	 /XEWtublZX7+G+CiMcu5n35KYL/vZz2NjM/gMGcwwVzbqkCam0cd008xfMGXCLxnKTdwK
	 4boIdF+HCN/WAOs+248/VgfW4JmsUoVvLbEB9KyQ1XI/aKa136YQ+R/IDFy7kLofxqb/B
	 nYJF7IqFLrSdfa81Yu/i5ahD6Fo2QIjLeGddWy6ZDhUpzhlsQDUi5wNusi/vETIPoet2q
	 Nk3rskvhZVfEtdkNInfDSHS3Zkb8IlKBlv6Dca77CeSwkx+OCxl1M0x1GjNn8WdwpBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wyDpR6VM1iHmBbraYRkux+91rClkM/xfWmXx+JogYMA=;
	b=oEc7C8zG26lQxggfAFzL8GgYgfYyPp8MWXvgslZvCiqpaQKL7MtO0l11pJEvE52KlCFI
	 jh0R9AkDZtUcBDlNKUX+cEfHD4CAR+AtngeopRe6JR+kHF46pVv0CULUCKTx/sqz7uZxs
	 hQd1NBRMhpqlAgbWGR91MM2vKDGcPdRgXYw9UM3pIv44lzW73nB6m7K8VcxBhvKoLQcc4
	 kNBPB7CXOmUjYoBpoyas7h4t0Nze5w1zYJ5gAijqM/M6UdExXE9Hw9ulhPVzwphI6Gj6r
	 cEhyVrLEz8rR98WP3vpaTLZpSBCJfo/OPGa2/M2eko4iyPmKzk3hBjo2RzoO1i7bxnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E6ACvN3Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1490F606A327;
	Wed, 25 Nov 2026 17:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E6ACvN3Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA991F000C4;
	Wed, 25 Nov 2026 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626017;
	bh=wyDpR6VM1iHmBbraYRkux+91rClkM/xfWmXx+JogYMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6ACvN3QHu/NJZrFoQiQMEjlZph10KDq1MZiaej0VSnZz9Y2P8Z+X7w+3D4U7vR9C
	 crph3Xmw85QeDbvexpJc/zpFwJgOUp+YgVsB3VaUvUzCfxjAkW0OkijXV040GJgVda
	 wCSLYRdqTFyO9zcecMqA8dqPm44CBmCxcUDTZbBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 702/816] dm persistent data: dont ignore writeback errors
Date: Wed, 25 Nov 2026 15:37:30 +0100
Message-ID: <20261125143905.431205029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit fa887f2ebee7aff97eb87b3365939616ade09774 upstream.

An error returned by ie_cache_writeback could be silently overwritten by
another successful ie_cache_writeback. This commit fixes disk_ll_commit,
so that it doesn't ignore the error and returns it immediatelly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 6b06dd5a9722 ("dm space map disk: cache a small number of index entries")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-space-map-common.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -1190,17 +1190,20 @@ static dm_block_t disk_ll_max_entries(st
 
 static int disk_ll_commit(struct ll_disk *ll)
 {
-	int r = 0;
+	int r;
 	unsigned int i;
 
 	for (i = 0; i < IE_CACHE_SIZE; i++) {
 		struct ie_cache *iec = ll->ie_cache + i;
 
-		if (iec->valid && iec->dirty)
+		if (iec->valid && iec->dirty) {
 			r = ie_cache_writeback(ll, iec);
+			if (unlikely(r))
+				return r;
+		}
 	}
 
-	return r;
+	return 0;
 }
 
 int sm_ll_new_disk(struct ll_disk *ll, struct dm_transaction_manager *tm)


