Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D6426F449;
	Tue, 27 May 2025 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366818; cv=none; b=NA+OPEGvKQ2AsbUXbj0SCal2PT4bYbt8/6PlrDqM58gn3X9MPGGAIlzJkw0oJ/4aCASNRT/yLouWiu9tZQ1JVEqGDeU4zxRP7r+OKAfVaePObPG3QEdC4yob5e6DFUk2yXU94+0fVqRmTML6RO5gPYWunlN6WpKZivBd4BLcTsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366818; c=relaxed/simple;
	bh=EoTzmzAA9bNyjzy/T1ArjTUimHEUMe7EygNB+hnQWsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELsWdCLdUm+pm4yGDfCbgPZNre7KoqZRr08vQcTB3SZMuJo3Q/sqJv/lnejUkNyumacrUu7GFhDyAj5wxCdD+PYU0vy90chyUYcOozdolVI6AxrXAT6FgbxATy7bFPBJXQT2nIjrI/+570/9x0Mrkcv7g50zMRImwGqczWOJkfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcomyrOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcomyrOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324D8C4CEE9;
	Tue, 27 May 2025 17:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366818;
	bh=EoTzmzAA9bNyjzy/T1ArjTUimHEUMe7EygNB+hnQWsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcomyrOSLuQSFPU2WsjIps61MiYVYpkQ4/DOIbwqES8gp9OdT7PVWUmxarOq+y76r
	 N+rBQl+1EuH62xGFeN0STRkHYahgsFd/S332vIdOatJYg3T2wAepnTsQxgFnlavPRg
	 maiDaDcBAlwW1pIixwEXR3jOm6jbskTNNvrlRudg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Jeremiah Lokan <jeremiahx.j.lokan@intel.com>
Subject: [PATCH 6.14 155/783] ixgbe: add support for thermal sensor event reception
Date: Tue, 27 May 2025 18:19:12 +0200
Message-ID: <20250527162519.475059645@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit affead2d904e8f82c0b89e23b3835242eb8c3e1a ]

E610 NICs unlike the previous devices utilising ixgbe driver
are notified in the case of overheating by the FW ACI event.

In event of overheat when threshold is exceeded, FW suspends all
traffic and sends overtemp event to the driver. Then driver
logs appropriate message and disables the adapter instance.
The card remains in that state until the platform is rebooted.

This approach is a solution to the fact current version of the
E610 FW doesn't support reading thermal sensor data by the
SW. So give to user at least any info that overtemp event
has occurred, without interface disappearing from the OS
without any note.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Jeremiah Lokan <jeremiahx.j.lokan@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20250310174502.3708121-7-anthony.l.nguyen@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 4 ++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 467f81239e12f..481f917f7ed28 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -3185,6 +3185,10 @@ static void ixgbe_handle_fw_event(struct ixgbe_adapter *adapter)
 		case ixgbe_aci_opc_get_link_status:
 			ixgbe_handle_link_status_event(adapter, &event);
 			break;
+		case ixgbe_aci_opc_temp_tca_event:
+			e_crit(drv, "%s\n", ixgbe_overheat_msg);
+			ixgbe_down(adapter);
+			break;
 		default:
 			e_warn(hw, "unknown FW async event captured\n");
 			break;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h
index 8d06ade3c7cd9..617e07878e4f7 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h
@@ -171,6 +171,9 @@ enum ixgbe_aci_opc {
 	ixgbe_aci_opc_done_alt_write			= 0x0904,
 	ixgbe_aci_opc_clear_port_alt_write		= 0x0906,
 
+	/* TCA Events */
+	ixgbe_aci_opc_temp_tca_event                    = 0x0C94,
+
 	/* debug commands */
 	ixgbe_aci_opc_debug_dump_internals		= 0xFF08,
 
-- 
2.39.5



