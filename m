Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E31C3A7F6F;
	Mon, 20 Apr 2026 13:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690979; cv=none; b=S+tCy7M3Ufr/KGyA2r3VoFXwVV8LotnqjY1GHrSn9fkIMwn1sfaQY1b/8kVUmc5c65s4MxTrvugSNpLttc0ocVBMoGNRJQRqY69fglxeqaDUO99va5b4+gJByFdsslmjKpzY1xxq8yqbDruHKp8hTl8loykXbhCZVcIa376k0BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690979; c=relaxed/simple;
	bh=49HN6o4yrsP/WG3TNcVwqMVx1kYceSAQjTh2AygBxfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfEiKUpO4HVIDToFIvqQQLoNd1EWHY53b4HuHHmr62iLrLNv7iDgWBJA287jFeiLfZWWZ5yeZrPG3S1wSYa6Ac6+56wk6UMqMnns3uSIOzIqQ02q3XCasXp/G3ItVZge7WNcTv0enGL2ZaFzs5ru2qo8jPNYMJcwtUSw9RrRJSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cqdZgMY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cqdZgMY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B71C2BCF6;
	Mon, 20 Apr 2026 13:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690978;
	bh=49HN6o4yrsP/WG3TNcVwqMVx1kYceSAQjTh2AygBxfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqdZgMY8OvAgJFp3z9cW5IWD8UEHaBY8Uvnn8ROOOnxVIBbjrD1bvMK1tFpts+ue7
	 qh3G+7Nn0YBabBCA8jAFznzZ1sJ6RFoLJNo8t4Vuu3SHagFJoPvqEuRKMzWkM9Ph0U
	 jZ+70Gy6z3ve+EMLQmFCqhx5KApX0GxxYNP3lBnqm2MKEhulpfN6zmIRHHhVsBVo3I
	 IKFrQM1bpYsOuX8FOp51K7Il/sU5ws9z6ROWUXJaY2Eg3eWJsLa3fTTbQswmVLGlEz
	 ruJNbK8KR+YrF8CHd0G4y5Qx9Bzj/kMtwCepJRyeMNrW+7syvBCs3enWkJMBXEOZjX
	 I3iLElrGcsaWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Agalakov Daniil <ade@amicon.ru>,
	Iskhakov Daniil <dish@amicon.ru>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	jesse.brandeburg@intel.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] e1000: check return value of e1000_read_eeprom
Date: Mon, 20 Apr 2026 09:08:08 -0400
Message-ID: <20260420131539.986432-22-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Agalakov Daniil <ade@amicon.ru>

[ Upstream commit d3baa34a470771399c1495bc04b1e26ac15d598e ]

[Why]
e1000_set_eeprom() performs a read-modify-write operation when the write
range is not word-aligned. This requires reading the first and last words
of the range from the EEPROM to preserve the unmodified bytes.

However, the code does not check the return value of e1000_read_eeprom().
If the read fails, the operation continues using uninitialized data from
eeprom_buff. This results in corrupted data being written back to the
EEPROM for the boundary words.

Add the missing error checks and abort the operation if reading fails.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-developed-by: Iskhakov Daniil <dish@amicon.ru>
Signed-off-by: Iskhakov Daniil <dish@amicon.ru>
Signed-off-by: Agalakov Daniil <ade@amicon.ru>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 726365c567ef3..75d0bfa7530b4 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -496,14 +496,19 @@ static int e1000_set_eeprom(struct net_device *netdev,
 		 */
 		ret_val = e1000_read_eeprom(hw, first_word, 1,
 					    &eeprom_buff[0]);
+		if (ret_val)
+			goto out;
+
 		ptr++;
 	}
-	if (((eeprom->offset + eeprom->len) & 1) && (ret_val == 0)) {
+	if ((eeprom->offset + eeprom->len) & 1) {
 		/* need read/modify/write of last changed EEPROM word
 		 * only the first byte of the word is being modified
 		 */
 		ret_val = e1000_read_eeprom(hw, last_word, 1,
 					    &eeprom_buff[last_word - first_word]);
+		if (ret_val)
+			goto out;
 	}
 
 	/* Device's eeprom is always little-endian, word addressable */
@@ -522,6 +527,7 @@ static int e1000_set_eeprom(struct net_device *netdev,
 	if ((ret_val == 0) && (first_word <= EEPROM_CHECKSUM_REG))
 		e1000_update_eeprom_checksum(hw);
 
+out:
 	kfree(eeprom_buff);
 	return ret_val;
 }
-- 
2.53.0

