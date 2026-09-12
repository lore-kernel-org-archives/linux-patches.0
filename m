Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561443A0B36;
	Sat, 12 Sep 2026 11:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211002; cv=none; b=QRkOdeWmUhnTbByO4VThyWto+CbynufyF49GoD8egB9z33KbMHu4xPsAfRRSgPWbAR7m7GpxMnh/ft+bnT/i6JPHuCXlmvW085ZzQ2QhqKknbetf5MObwjRlMwzf/l2Ie1AD2bkBa3VhpkI5kAvN/rvQrItx/+WNN2/gVI+PYJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211002; c=relaxed/simple;
	bh=dD9Eo/4ZbbpVJlvfP/BcT/+laZrZ0CeUgFm8bRU4qnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Op8+W17Hfqn83Tg9TtsJfuWXizVOzvnhc0oc+ixh3LZTq9G45kB7vMUvfDy7QFXtwb9YDzhO6MtgOipXiV+BDXeCrZ+aEHYEvQTqRvIT5LPkQ+UfHEukLEpqAdDb28lt6irUavne7ydvV8jSgjJDkRrtaSFSD45kMifzOpsFTOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9tbpiFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9tbpiFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3ECE1F000FF;
	Sat, 12 Sep 2026 11:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210999;
	bh=TyT0wVCnUSQYE6oxo3vUk21YKU+uZyP8VlJ4duWjzuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9tbpiFvjQie2tNMXKcr8YmusEhuBIF9gw83EkKwlzMAKa8f+FOwy/WvGjjCG3TMN
	 OC7m/4YVhpCH2D1v5tLpNOr5aMMPLYNW95EQ1s8gPNovtfMcmI0WaUx26kNVrK+dC+
	 utGg8XlpmTRamulbYrptSEA0yMvbrurIx5sG717A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1140/1518] idpf: add missing cpu_to_le32 in idpf_tx_splitq_build_flow_desc
Date: Sat, 12 Sep 2026 08:55:09 +0200
Message-ID: <20260912065649.247379255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit b802a8c1ca16f9490fa0cb3110c00c10d52b392d ]

idpf_tx_splitq_build_flow_desc performs a 32-bit store to &cmd_dtype
to set the 8-bit cmd_dtype and zero the adjacent 3-byte timestamp
field in a single operation.

Descriptors are in little endian. Add missing cpu_to_le32 and cast to
__le32 to ensure the fields are written correctly also on big endian
platforms.

Fixes: 1a49cf814fe1 ("idpf: add Tx timestamp flows")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index e6563ad31f5ca..4a4e00c70d93e 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -2392,7 +2392,7 @@ void idpf_tx_splitq_build_flow_desc(union idpf_tx_flex_desc *desc,
 				    struct idpf_tx_splitq_params *params,
 				    u16 td_cmd, u16 size)
 {
-	*(u32 *)&desc->flow.qw1.cmd_dtype = (u8)(params->dtype | td_cmd);
+	*(__le32 *)&desc->flow.qw1.cmd_dtype = cpu_to_le32((u8)(params->dtype | td_cmd));
 	desc->flow.qw1.rxr_bufsize = cpu_to_le16((u16)size);
 	desc->flow.qw1.compl_tag = cpu_to_le16(params->compl_tag);
 }
-- 
2.53.0



