Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE72A1B8;
	Sun,  1 Sep 2024 16:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209823; cv=none; b=seJlmQF+lb9N/75B8J+DVDdSLuLy6FMATBGP20pZVALXzCYPXE0H/tCAYqe+02I2C5LXAbAAfcJJG/Cwpaj3TzILWYRGWd+crdb/VaTQO2rKKbhdQcSe2hlG8yNkb505ZxtxjcefxLQC2eg8LOAsIT5cYTUevBax5P7DGnfcrIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209823; c=relaxed/simple;
	bh=RouQDi8LkXJ5gwndn2KTUfyW2Fd3gYVybBp19iPIsFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCeKO36c8rKa35Y2sUuYoIuIQwXm/5pEWrl7Bg2vMz0+8+3+D9YXoiodM0+JO4M+uCJdSl4JYYIGaMgRMiaGMq4RLMF9Tx/KPxlHqY/sriF3QDIButn6Zh7B09nVqwh8bbL1aFxpOAzxhAgkVT63Su/N+QTCzG6PtLc2xtTpkf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwCO0nxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwCO0nxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EFCC4CEC3;
	Sun,  1 Sep 2024 16:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209823;
	bh=RouQDi8LkXJ5gwndn2KTUfyW2Fd3gYVybBp19iPIsFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwCO0nxQ0xlWpoAW+9QTmjBSsrsIGX4TitxCADkyMSQ1OIt0OkAe9t91l/GQPSoO0
	 kzr3uzQb1hMiWRidUv0OaFal0wiKsbeKB/zrl/A8DUVpi1Y0sOY2O0SvADJeGSIijQ
	 2ZOD2dr2zyZDLt7WgZA5NaeBE1OKk7hY00pRh2vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 135/151] soundwire: stream: fix programming slave ports for non-continous port maps
Date: Sun,  1 Sep 2024 18:18:15 +0200
Message-ID: <20240901160819.183874052@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit ab8d66d132bc8f1992d3eb6cab8d32dda6733c84 upstream.

Two bitmasks in 'struct sdw_slave_prop' - 'source_ports' and
'sink_ports' - define which ports to program in
sdw_program_slave_port_params().  The masks are used to get the
appropriate data port properties ('struct sdw_get_slave_dpn_prop') from
an array.

Bitmasks can be non-continuous or can start from index different than 0,
thus when looking for matching port property for given port, we must
iterate over mask bits, not from 0 up to number of ports.

This fixes allocation and programming slave ports, when a source or sink
masks start from further index.

Fixes: f8101c74aa54 ("soundwire: Add Master and Slave port programming")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240729140157.326450-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/stream.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1425,18 +1425,18 @@ struct sdw_dpn_prop *sdw_get_slave_dpn_p
 					    unsigned int port_num)
 {
 	struct sdw_dpn_prop *dpn_prop;
-	u8 num_ports;
+	unsigned long mask;
 	int i;
 
 	if (direction == SDW_DATA_DIR_TX) {
-		num_ports = hweight32(slave->prop.source_ports);
+		mask = slave->prop.source_ports;
 		dpn_prop = slave->prop.src_dpn_prop;
 	} else {
-		num_ports = hweight32(slave->prop.sink_ports);
+		mask = slave->prop.sink_ports;
 		dpn_prop = slave->prop.sink_dpn_prop;
 	}
 
-	for (i = 0; i < num_ports; i++) {
+	for_each_set_bit(i, &mask, 32) {
 		if (dpn_prop[i].num == port_num)
 			return &dpn_prop[i];
 	}


