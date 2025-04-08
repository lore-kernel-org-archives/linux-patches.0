Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F50267F68;
	Tue,  8 Apr 2025 11:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113107; cv=none; b=bTzZt7XmB+/qaR8rhJJLZx/o9Oqmoo0jw6+YlgGJq1pTdCvKotz+rP3EAvm5s36z88kAianUYtoDNPpZ9K7dmZDrW3NmsbLaN1smfypIYVgmij55FTW8qkAer9HhAbdhx6pvSYm7gOcRS+sZFLTUnog3RF5z/kkaec4PSK94o7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113107; c=relaxed/simple;
	bh=x8PLsyDKKdvh4C96jBIiztgcnXER8dcmKgjNkfA93s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSOO7+BGn3caJgHuFFDmhnyE85qPsgAUE8ZSrB+1yV2JSKofTSd/2fpjD5y4/40WBJ0bBj7twaOm/ge70wxPbba5Il0BMvHFOV60eUQumzUdbqkYvB8qdeqcxFZBtjm/3qf4n6aBf2/sOOadYz882NqoMzQoK7N32EQxD4Qv0KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJN4NoJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJN4NoJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022D1C4CEE5;
	Tue,  8 Apr 2025 11:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113107;
	bh=x8PLsyDKKdvh4C96jBIiztgcnXER8dcmKgjNkfA93s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJN4NoJDQZOPMYTdH25su3oijllk2mtjARghExkiCoqWdSYTXc/Y8QLV5L5SvJ+s1
	 0u64S+44ZKsgRm/SdHbDwPQLLCuUyy47CJNnpbWQ7L9ZXiuW5VN3SEppPBjWEH+1Oi
	 bj5HATxgAVEiOF9ArIsnlM+wu6HJO2U1OoCohSoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Carol Soto <csoto@nvidia.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Chris Chiu <chris.chiu@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/268] PCI: Use downstream bridges for distributing resources
Date: Tue,  8 Apr 2025 12:47:28 +0200
Message-ID: <20250408104829.500587482@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai-Heng Feng <kaihengf@nvidia.com>

[ Upstream commit 1a596ad00ffe9b37fc60a93cbdd4daead3bf95f3 ]

7180c1d08639 ("PCI: Distribute available resources for root buses, too")
breaks BAR assignment on some devices:

  pci 0006:03:00.0: BAR 0 [mem 0x6300c0000000-0x6300c1ffffff 64bit pref]: assigned
  pci 0006:03:00.1: BAR 0 [mem 0x6300c2000000-0x6300c3ffffff 64bit pref]: assigned
  pci 0006:03:00.2: BAR 0 [mem size 0x00800000 64bit pref]: can't assign; no space
  pci 0006:03:00.0: VF BAR 0 [mem size 0x02000000 64bit pref]: can't assign; no space
  pci 0006:03:00.1: VF BAR 0 [mem size 0x02000000 64bit pref]: can't assign; no space

The apertures of domain 0006 before 7180c1d08639:

  6300c0000000-63ffffffffff : PCI Bus 0006:00
    6300c0000000-6300c9ffffff : PCI Bus 0006:01
      6300c0000000-6300c9ffffff : PCI Bus 0006:02        # 160MB
        6300c0000000-6300c8ffffff : PCI Bus 0006:03      #   144MB
          6300c0000000-6300c1ffffff : 0006:03:00.0       #     32MB
          6300c2000000-6300c3ffffff : 0006:03:00.1       #     32MB
          6300c4000000-6300c47fffff : 0006:03:00.2       #      8MB
          6300c4800000-6300c67fffff : 0006:03:00.0       #     32MB
          6300c6800000-6300c87fffff : 0006:03:00.1       #     32MB
        6300c9000000-6300c9bfffff : PCI Bus 0006:04      #    12MB
          6300c9000000-6300c9bfffff : PCI Bus 0006:05    #    12MB
            6300c9000000-6300c91fffff : PCI Bus 0006:06  #      2MB
            6300c9200000-6300c93fffff : PCI Bus 0006:07  #      2MB
            6300c9400000-6300c95fffff : PCI Bus 0006:08  #      2MB
            6300c9600000-6300c97fffff : PCI Bus 0006:09  #      2MB

After 7180c1d08639:

  6300c0000000-63ffffffffff : PCI Bus 0006:00
    6300c0000000-6300c9ffffff : PCI Bus 0006:01
      6300c0000000-6300c9ffffff : PCI Bus 0006:02        # 160MB
        6300c0000000-6300c43fffff : PCI Bus 0006:03      #    68MB
          6300c0000000-6300c1ffffff : 0006:03:00.0       #      32MB
          6300c2000000-6300c3ffffff : 0006:03:00.1       #      32MB
              --- no space ---      : 0006:03:00.2       #       8MB
              --- no space ---      : 0006:03:00.0       #      32MB
              --- no space ---      : 0006:03:00.1       #      32MB
        6300c4400000-6300c4dfffff : PCI Bus 0006:04      #    10MB
          6300c4400000-6300c4dfffff : PCI Bus 0006:05    #      10MB
            6300c4400000-6300c45fffff : PCI Bus 0006:06  #        2MB
            6300c4600000-6300c47fffff : PCI Bus 0006:07  #        2MB
            6300c4800000-6300c49fffff : PCI Bus 0006:08  #        2MB
            6300c4a00000-6300c4bfffff : PCI Bus 0006:09  #        2MB

We can see that the window to 0006:03 gets shrunken too much and 0006:04
eats away the window for 0006:03:00.2.

The offending commit distributes the upstream bridge's resources multiple
times to every downstream bridge, hence makes the aperture smaller than
desired because calculation of io_per_b, mmio_per_b and mmio_pref_per_b
becomes incorrect.

Instead, distribute downstream bridges' own resources to resolve the issue.

Link: https://lore.kernel.org/r/20241204022457.51322-1-kaihengf@nvidia.com
Fixes: 7180c1d08639 ("PCI: Distribute available resources for root buses, too")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219540
Signed-off-by: Kai-Heng Feng <kaihengf@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Carol Soto <csoto@nvidia.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 5a143ad5fca24..fba402f4f6330 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2018,8 +2018,7 @@ pci_root_bus_distribute_available_resources(struct pci_bus *bus,
 		 * in case of root bus.
 		 */
 		if (bridge && pci_bridge_resources_not_assigned(dev))
-			pci_bridge_distribute_available_resources(bridge,
-								  add_list);
+			pci_bridge_distribute_available_resources(dev, add_list);
 		else
 			pci_root_bus_distribute_available_resources(b, add_list);
 	}
-- 
2.39.5



