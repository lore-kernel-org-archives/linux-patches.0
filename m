Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9B8126BF7;
	Tue, 29 Apr 2025 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945326; cv=none; b=EnUbtODOnQut4Hs6IWrgF7ivs7AJYb88DzX7KKtyC+7PcpwNdcDOH1Nk4l0/fC7Hh52T8UzO4xV05mjWruzsUElVUlWrFGelXWg11Dv5PIzS6t8zf0GvOqbnqzHqClz0bK9BQV37KSWT68vZyNV/fj2fH7V1y84VFZj9tO5Ebnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945326; c=relaxed/simple;
	bh=mz58rFw/voBn6bQKOsn3JWhfxPYhHfjWqKw/Xj3CuV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRw7Im0yvkL4ATqIPanz0IGG3TsKlNhpXUm2WJICXfpsMNIyYK1kIs+ab+CENh5zElzI/LIPBsHob/+/4L9F9Lklp/AS6NcTHjRGoQCn9Hz2qP9RY9ttGJ6TOCDnMPTgWYZ3Rzmpyn1lWB96iuH/mfYg/DRdHWTTqXfblqFa4H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrFVRn5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrFVRn5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D10C4CEE3;
	Tue, 29 Apr 2025 16:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945325;
	bh=mz58rFw/voBn6bQKOsn3JWhfxPYhHfjWqKw/Xj3CuV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrFVRn5NoSWgqbpkpZ9x8RNKYSoxDs1spYyBM86ktyNMRcCtHj/KBw4guu0Y3bdwB
	 p8EJOCorDwnddbKeq/BPguulEfwZCxzW7Db466JLUJUSuA9ARRXFciRyMECM7PZWrE
	 wHxRQaGWaDQXP2HI4PmdZlNspeW1ks2v6Wv5Wj9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.4 074/179] ntb: use 64-bit arithmetic for the MSI doorbell mask
Date: Tue, 29 Apr 2025 18:40:15 +0200
Message-ID: <20250429161052.408543194@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit fd5625fc86922f36bedee5846fefd647b7e72751 upstream.

msi_db_mask is of type 'u64', still the standard 'int' arithmetic is
performed to compute its value.

While most of the ntb_hw drivers actually don't utilize the higher 32
bits of the doorbell mask now, this may be the case for Switchtec - see
switchtec_ntb_init_db().

Found by Linux Verification Center (linuxtesting.org) with SVACE static
analysis tool.

Fixes: 2b0569b3b7e6 ("NTB: Add MSI interrupt support to ntb_transport")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1340,7 +1340,7 @@ static int ntb_transport_probe(struct nt
 	qp_count = ilog2(qp_bitmap);
 	if (nt->use_msi) {
 		qp_count -= 1;
-		nt->msi_db_mask = 1 << qp_count;
+		nt->msi_db_mask = BIT_ULL(qp_count);
 		ntb_db_clear_mask(ndev, nt->msi_db_mask);
 	}
 


