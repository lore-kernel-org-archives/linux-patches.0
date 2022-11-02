Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EE5633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4562C433C1;
	Wed,  2 Nov 2022 03:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360409;
	bh=qjbVVckJv5lM0mpalgOdpAIyiM05mLgJ4vVg0UoZ8zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DluHFOwyXVXj9aa/dnt53fKobgBduL7LX3WLGX8DwRudUZ4pdX/l6vv6mqpZwZJsR
	 CgZMi5PUg2kJnL5itmCzD1QizR/yZOPtlXLBJLCtdd+DKHAVCaRrQBJ6nG0mFyNN90
	 lB6m8GtMzfq9mZjIBps3eI6rcnhbtpJbJCubJKfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Eric Ren <renzhengeek@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.14 06/60] KVM: arm64: vgic: Fix exit condition in scan_its_table()
Date: Wed,  2 Nov 2022 03:34:27 +0100
Message-Id: <20221102022051.278191419@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Ren <renzhengeek@gmail.com>

commit c000a2607145d28b06c697f968491372ea56c23a upstream.

With some PCIe topologies, restoring a guest fails while
parsing the ITS device tables.

Reproducer hints:
1. Create ARM virt VM with pxb-pcie bus which adds
   extra host bridges, with qemu command like:

```
  -device pxb-pcie,bus_nr=8,id=pci.x,numa_node=0,bus=pcie.0 \
  -device pcie-root-port,..,bus=pci.x \
  ...
  -device pxb-pcie,bus_nr=37,id=pci.y,numa_node=1,bus=pcie.0 \
  -device pcie-root-port,..,bus=pci.y \
  ...

```
2. Ensure the guest uses 2-level device table
3. Perform VM migration which calls save/restore device tables

In that setup, we get a big "offset" between 2 device_ids,
which makes unsigned "len" round up a big positive number,
causing the scan loop to continue with a bad GPA. For example:

1. L1 table has 2 entries;
2. and we are now scanning at L2 table entry index 2075 (pointed
   to by L1 first entry)
3. if next device id is 9472, we will get a big offset: 7397;
4. with unsigned 'len', 'len -= offset * esz', len will underflow to a
   positive number, mistakenly into next iteration with a bad GPA;
   (It should break out of the current L2 table scanning, and jump
   into the next L1 table entry)
5. that bad GPA fails the guest read.

Fix it by stopping the L2 table scan when the next device id is
outside of the current table, allowing the scan to continue from
the next L1 table entry.

Thanks to Eric Auger for the fix suggestion.

Fixes: 920a7a8fa92a ("KVM: arm64: vgic-its: Add infrastructure for tableookup")
Suggested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Eric Ren <renzhengeek@gmail.com>
[maz: commit message tidy-up]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/d9c3a564af9e2c5bf63f48a7dcbf08cd593c5c0b.1665802985.git.renzhengeek@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/arm/vgic/vgic-its.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1835,7 +1835,7 @@ static int scan_its_table(struct vgic_it
 
 	memset(entry, 0, esz);
 
-	while (len > 0) {
+	while (true) {
 		int next_offset;
 		size_t byte_offset;
 
@@ -1848,6 +1848,9 @@ static int scan_its_table(struct vgic_it
 			return next_offset;
 
 		byte_offset = next_offset * esz;
+		if (byte_offset >= len)
+			break;
+
 		id += next_offset;
 		gpa += byte_offset;
 		len -= byte_offset;


