Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4486183CDB;
	Sun,  1 Sep 2024 16:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208431; cv=none; b=a6FI9oWOnV8jQQRRX83cFqouqQmkTrQuJmVA6UyRaPkg77Sxss/KqtfXGN+Rxwlcs/UVsalH39D4HKTuw1oKr6OQHOzO7wAwLAiRBQaruuvxNPZ+vrb7Z0Q4dce2qGHMULIiyy2gh10yAcW1Y2meUnLN4nRYnZkN5XWjjdfLv4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208431; c=relaxed/simple;
	bh=Dcl75eP1JdYDBd0Izfnz5RSiiTHdSzJYonVFq6UcLgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxp/VZi/DJ8q9gqJ3ag9TQ9JGF0nuUbfv2i9GH4Bzh8ockV20Js6EZ3Z0dDA7TJQdXVTY49k91lLULoGiKMPYbBmQhXCJcOKA5Df0tzdiX7pmGoHNbU1YmKbl7J/aNw45g+9WLF5PgCkMSqv4ulXfj+n+yQtExrRwKwf5NfoNEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7De1/Bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7De1/Bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48602C4CEC3;
	Sun,  1 Sep 2024 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208431;
	bh=Dcl75eP1JdYDBd0Izfnz5RSiiTHdSzJYonVFq6UcLgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7De1/Bo3qYgSsZGD4sDrWNMayRNTdRzCQOG3hqKMcJbpMh6PSFGE9hs7SNPTeTiI
	 0+htYFLGz56b8tHKzV6ow/ps/kg+WLYJMpQFRnos/nMK/b5e+wBfHPVZgUVDY1PZ/Y
	 KiOsQMFg5s8naWxU0NjQJ/5faR7O8Fnp3qeMS0/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.10 080/149] soundwire: stream: fix programming slave ports for non-continous port maps
Date: Sun,  1 Sep 2024 18:16:31 +0200
Message-ID: <20240901160820.478005976@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1286,18 +1286,18 @@ struct sdw_dpn_prop *sdw_get_slave_dpn_p
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


