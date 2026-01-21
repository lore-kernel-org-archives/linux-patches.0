Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5E739B4BB;
	Wed, 21 Jan 2026 18:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020141; cv=none; b=eqM4oojmkwuLga/UD58T+F/JctOPMZPT0RcilY/GeZYS2Am0NvanLTxFTMS+oYJ/WAkQ1RTeYXJx7sg9L/WeqQe9vdBTa/+EFJeoR1TpY4cJ/OGYZk6ckKJI8+j2qQ9Oz0cI1B6cUy07bLsY896Xg0DoEcrsCu0DID7q23DT1yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020141; c=relaxed/simple;
	bh=lNVqk79LCSlNksbc82TSUTtHpB8rMWTXqPA20fTN2Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xx2DjbNay+faZWZv8uXdHgBj52VPdH8DFusA/ahcqle8LKk0alkHA5uKDeYo9oE89s6Dvap9fX+TV/+R7eBbyVpNlBw2Id08UtNapkQWX3JoethZCxPT8blSvmiVJE0o3s4/gJzCrxbsCQVYPcqEW9/bdvUChmc9c2yVRFRuXVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fTTmyqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fTTmyqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538B6C16AAE;
	Wed, 21 Jan 2026 18:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020141;
	bh=lNVqk79LCSlNksbc82TSUTtHpB8rMWTXqPA20fTN2Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fTTmyqxCNPGNH/TZcpfACwdKcY9unJXEdCNWPhbtP0sAaPICxbjLgmy9kSgdoI5B
	 0WPacIWBLQm91esZ8aexyGptafYA0WNzIU5XfEctWOQVaKc1gkPWmJ2hKUVqQDtbW1
	 VqUnGUrfnVHHyW8RL2g1O1ELtZXJQcY1SsXn2syc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Robert Richter <rrichter@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/198] cxl/port: Fix target list setup for multiple decoders sharing the same dport
Date: Wed, 21 Jan 2026 19:14:16 +0100
Message-ID: <20260121181419.567513976@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Robert Richter <rrichter@amd.com>

[ Upstream commit 3e8aaacdad4f66641f87ab441fe644b45f8ebdff ]

If a switch port has more than one decoder that is using the same
downstream port, the enumeration of the target lists may fail with:

 # dmesg | grep target.list
 update_decoder_targets: cxl decoder1.0: dport3 found in target list, index 3
 update_decoder_targets: cxl decoder1.0: dport2 found in target list, index 2
 update_decoder_targets: cxl decoder1.0: dport0 found in target list, index 0
 update_decoder_targets: cxl decoder2.0: dport3 found in target list, index 1
 update_decoder_targets: cxl decoder4.0: dport3 found in target list, index 1
 cxl_mem mem6: failed to find endpoint12:0000:00:01.4 in target list of decoder2.1
 cxl_mem mem8: failed to find endpoint13:0000:20:01.4 in target list of decoder4.1

The case, that the same downstream port can be used in multiple target
lists, is allowed and possible.

Fix the update of the target list. Enumerate all children of the
switch port and do not stop the iteration after the first matching
target was found.

With the fix applied:

 # dmesg | grep target.list
 update_decoder_targets: cxl decoder1.0: dport2 found in target list, index 2
 update_decoder_targets: cxl decoder1.0: dport0 found in target list, index 0
 update_decoder_targets: cxl decoder1.0: dport3 found in target list, index 3
 update_decoder_targets: cxl decoder2.0: dport3 found in target list, index 1
 update_decoder_targets: cxl decoder2.1: dport3 found in target list, index 1
 update_decoder_targets: cxl decoder4.0: dport3 found in target list, index 1
 update_decoder_targets: cxl decoder4.1: dport3 found in target list, index 1

Analyzing the conditions when this happens:

1) A dport is shared by multiple decoders.

2) The decoders have interleaving configured (ways > 1).

The configuration above has the following hierarchy details (fixed
version):

 root0
 |_
 | |
 | decoder0.1
 | ways: 2
 | target_list: 0,1
 |_______________________________________
 |                                       |
 | dport0                                | dport1
 |                                       |
 port2                                   port4
 |                                       |
 |___________________                    |_____________________
 | |                 |                   | |                   |
 | decoder2.0        decoder2.1          | decoder4.0          decoder4.1
 | ways: 2           ways: 2             | ways: 2             ways: 2
 | target_list: 2,3  target_list: 2,3    | target_list: 2,3    target_list: 2,3
 |___________________                    |___________________
 |                   |                   |                   |
 | dport2            | dport3            | dport2            | dport3
 |                   |                   |                   |
 endpoint7           endpoint12          endpoint9           endpoint13
 |_                  |_                  |_                  |_
 | |                 | |                 | |                 | |
 | decoder7.0        | decoder12.0       | decoder9.0        | decoder13.0
 | decoder7.2        | decoder12.2       | decoder9.2        | decoder13.2
 |                   |                   |                   |
 mem3                mem5                mem6                mem8

Note: Device numbers vary for every boot.

Current kernel fails to enumerate endpoint12 and endpoint13 as the
target list is not updated for the second decoder.

Fixes: 4f06d81e7c6a ("cxl: Defer dport allocation for switch ports")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Robert Richter <rrichter@amd.com>
Link: https://patch.msgid.link/20260108101324.509667-1-rrichter@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 8128fd2b5b317..804e4a48540f6 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1591,7 +1591,7 @@ static int update_decoder_targets(struct device *dev, void *data)
 			cxlsd->target[i] = dport;
 			dev_dbg(dev, "dport%d found in target list, index %d\n",
 				dport->port_id, i);
-			return 1;
+			return 0;
 		}
 	}
 
-- 
2.51.0



