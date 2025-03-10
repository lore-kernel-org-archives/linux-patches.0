Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC09018DB24;
	Mon, 10 Mar 2025 17:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628378; cv=none; b=ARyjNBU4f/Tv3/L/7c+ZMXk6WrdXccQIRFc27Q1CQ96g74CJqN1Xn6oF0CvEMhJfg8CWYnfIJ03f/vqdGDmGUj93IE9aNZN9Dj4ExgBT+3P55qNfCdAD9O0o6lSdUJDPbcdbiUpquzaYSqy0Jh5kIDRjd+ivuJOcoxeKrcHgHkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628378; c=relaxed/simple;
	bh=Z3RRMe+mLjuCDnqZyAxVHzAcVAxZuGcfxLaOCNeoc+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9hvkyp+SuvgF9k2fQT7JQiCqxzHUQu58ypTLAFwL6/gXeexwAJa/GeuPYwrlnOAaYstOaZxTKK1WoBPoIZQ9xCefUJB9yypGL4jV/lmsgksUXAi92ZotZOlyVBAtnxosPGe1TsQUZD4Ku69BMvnwvoDEsSB7rHscI6hMzaAyBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccjol8Mw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccjol8Mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57536C4CEED;
	Mon, 10 Mar 2025 17:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628377;
	bh=Z3RRMe+mLjuCDnqZyAxVHzAcVAxZuGcfxLaOCNeoc+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccjol8Mw+SOYXL/Yis7vhTqizYJsTW44/DomowJvPiKcwyd1cuDRnH9Gl/SC93Pnl
	 8UwlQ7JFoXOxpsbsGPvGsxFEbQFoKBi0sGDKNO5bspQsZ7ioTiKSbAjjaqzebEX4gI
	 TYhABdv6JO9WWwCtweFQumzpMVxfWYkpH3ezkWKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/109] wifi: iwlwifi: limit printed string from FW file
Date: Mon, 10 Mar 2025 18:06:21 +0100
Message-ID: <20250310170429.036973701@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e0dc2c1bef722cbf16ae557690861e5f91208129 ]

There's no guarantee here that the file is always with a
NUL-termination, so reading the string may read beyond the
end of the TLV. If that's the last TLV in the file, it can
perhaps even read beyond the end of the file buffer.

Fix that by limiting the print format to the size of the
buffer we have.

Fixes: aee1b6385e29 ("iwlwifi: support fseq tlv and print fseq version")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.cb5f9d0c2f5d.Idec695d53c6c2234aade306f7647b576c7e3d928@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 024c37062a60b..789393aa68cd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1141,7 +1141,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 
 			if (tlv_len != sizeof(*fseq_ver))
 				goto invalid_tlv_len;
-			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %s\n",
+			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %.32s\n",
 				 fseq_ver->version);
 			}
 			break;
-- 
2.39.5



