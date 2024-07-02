Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E09D16B394;
	Tue,  2 Jul 2024 17:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940530; cv=none; b=BOen2pMkacUH5MjP/govH16mcJw0ygz2QvrYyiJvIiVF1FRwEL2S24SvN+CioSZBVHRQQRO7EX56I/WdmYo4iZ8YK+3A2xu+pf988i/mjNKgl2J/+KcXtKMaupTHdkmYDDakDWuS/NOEZm542vz1V0ASH385xi8/hbGu02XcvHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940530; c=relaxed/simple;
	bh=BurpgmlbN+plYt0LLmS6kkyOJzQwcsEbKxPBMeIRdSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jw6xQhnGVYs7KTy+CtzE8befo+qtouXwUHYglmi7dBQ/vhMyB+RUeiSD0d+NILyMj/etPttAtZW0lo1shQkFTG01jA/AXN3FQBXV83FpTCeXh+WiOYK1X4WYlKYlaUeO8VQKjK/G+E2rzd90Mhe2tbdCAVcjXX5Z+OOCaEzENA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJ5DO1KZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJ5DO1KZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5440C116B1;
	Tue,  2 Jul 2024 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940530;
	bh=BurpgmlbN+plYt0LLmS6kkyOJzQwcsEbKxPBMeIRdSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJ5DO1KZcFLqpk4uz0QEWgIBYObnb2DLYfnFocHC13RSrySyZlOm5HucSrxWtwDQs
	 l8gc9HuAgF8G8l4Af//rr2MMehhzuZLskDCZjoAvdk/5sr9q8RwuGVLbqbKxmGWIgl
	 YUkGJG6E2bA7ig51Kmhg2aPtXHJmeauuxCLnXBk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.9 150/222] usb: typec: ucsi: glink: fix child node release in probe function
Date: Tue,  2 Jul 2024 19:03:08 +0200
Message-ID: <20240702170249.709614582@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit c68942624e254a4e8a65afcd3c17ed95acda5489 upstream.

The device_for_each_child_node() macro requires explicit calls to
fwnode_handle_put() in all early exits of the loop if the child node is
not required outside. Otherwise, the child node's refcount is not
decremented and the resource is not released.

The current implementation of pmic_glink_ucsi_probe() makes use of the
device_for_each_child_node(), but does not release the child node on
early returns. Add the missing calls to fwnode_handle_put().

Cc: stable@vger.kernel.org
Fixes: c6165ed2f425 ("usb: ucsi: glink: use the connector orientation GPIO to provide switch events")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240613-ucsi-glink-release-node-v1-1-f7629a56f70a@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -365,6 +365,7 @@ static int pmic_glink_ucsi_probe(struct
 		ret = fwnode_property_read_u32(fwnode, "reg", &port);
 		if (ret < 0) {
 			dev_err(dev, "missing reg property of %pOFn\n", fwnode);
+			fwnode_handle_put(fwnode);
 			return ret;
 		}
 
@@ -379,9 +380,11 @@ static int pmic_glink_ucsi_probe(struct
 		if (!desc)
 			continue;
 
-		if (IS_ERR(desc))
+		if (IS_ERR(desc)) {
+			fwnode_handle_put(fwnode);
 			return dev_err_probe(dev, PTR_ERR(desc),
 					     "unable to acquire orientation gpio\n");
+		}
 		ucsi->port_orientation[port] = desc;
 
 		ucsi->port_switch[port] = fwnode_typec_switch_get(fwnode);


