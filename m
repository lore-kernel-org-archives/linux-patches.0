Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4D513A26F;
	Tue, 27 Feb 2024 14:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042760; cv=none; b=blufx/MAZ2m/p8oyJ59tUpMsYppy0MY5ykfRc7cS3w5Szm0aspJuwZ9gPOGSU+vb7wBhIYvPCkl2KzvoIoJNvr8yAcSX6HKRE773FUcKT3pnUXpzXnUYxypVdLUeQRSaXAhZsqzB7esvqcdC04dApbr76jiWRZHlBQyh++xdelQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042760; c=relaxed/simple;
	bh=e8QA2LP1Rz80ZtVzJz5JvTlxfCuIYnm2Ppk5UVeLeV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgX4+odo5Ip0k2fPSLGiCjXUrNyCSKe1/JSSU7HI9eiAw9eXACdBznm3zxibtqVO//eDCUYpZF6cv6xdPp54D+2KmvQD/Xhjwkm5amcuofglNHDWrfmHXc6CP1CjkHN+vRP3iuHjtXgGvVbD+LY/PcRBiiMU/f5EGtsUowQX86o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOxK8yD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOxK8yD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45956C433C7;
	Tue, 27 Feb 2024 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042759;
	bh=e8QA2LP1Rz80ZtVzJz5JvTlxfCuIYnm2Ppk5UVeLeV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOxK8yD7dgkVrduzYm+GfZuzFMDm1hcHNzVBa+tOnyTQqbnEvREhUHza0bM4Xp3Wl
	 xhBuqXbVd6l5LBVMavShAKO5I+Ie0nwoIwXwxvXjhhFDeMWb+hrWprRYqOY5yHjL8Q
	 W/C7aYrqf+qadmgqnxtsMg1KacctzyqaDcnjJiWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/245] Input: iqs269a - drop unused device node references
Date: Tue, 27 Feb 2024 14:24:58 +0100
Message-ID: <20240227131618.798323197@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 59bc9cb3b80abaa42643abede0d5db8477901d9c ]

Each call to device/fwnode_get_named_child_node() must be matched
with a call to fwnode_handle_put() once the corresponding node is
no longer in use. This ensures a reference count remains balanced
in the case of dynamic device tree support.

Currently, the driver does not call fwnode_handle_put() on nested
event nodes. This patch solves this problem by adding the missing
instances of fwnode_handle_put().

As part of this change, the logic which parses each channel's key
code is gently refactored in order to reduce the number of places
from which fwnode_handle_put() is called.

Fixes: 04e49867fad1 ("Input: add support for Azoteq IQS269A")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/Y7Rsx68k/gvDVXAt@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs269a.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/input/misc/iqs269a.c b/drivers/input/misc/iqs269a.c
index a348247d3d38f..ea3c97c5f764f 100644
--- a/drivers/input/misc/iqs269a.c
+++ b/drivers/input/misc/iqs269a.c
@@ -694,6 +694,7 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 				dev_err(&client->dev,
 					"Invalid channel %u threshold: %u\n",
 					reg, val);
+				fwnode_handle_put(ev_node);
 				return -EINVAL;
 			}
 
@@ -707,6 +708,7 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 				dev_err(&client->dev,
 					"Invalid channel %u hysteresis: %u\n",
 					reg, val);
+				fwnode_handle_put(ev_node);
 				return -EINVAL;
 			}
 
@@ -721,8 +723,16 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 			}
 		}
 
-		if (fwnode_property_read_u32(ev_node, "linux,code", &val))
+		error = fwnode_property_read_u32(ev_node, "linux,code", &val);
+		fwnode_handle_put(ev_node);
+		if (error == -EINVAL) {
 			continue;
+		} else if (error) {
+			dev_err(&client->dev,
+				"Failed to read channel %u code: %d\n", reg,
+				error);
+			return error;
+		}
 
 		switch (reg) {
 		case IQS269_CHx_HALL_ACTIVE:
-- 
2.43.0



