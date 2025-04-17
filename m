Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C2E1EB1BF;
	Thu, 17 Apr 2025 18:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913679; cv=none; b=iNh8yrWdSBbvj6Ag5A25jWhQIzTCqfon5gGPuOv/qrCiLXtGK6x6+1rEcdLnsZWLWTX0PQUrGRAY45lCnQEREsIuNjbTnNIdOvVW5hSMCkF6Yu5aDybW7J77FtuxUbDuvWpwfODlKNN5bVuPApVbyc4qLV7uasLsMK71AoNcJGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913679; c=relaxed/simple;
	bh=w/UYUyLGfg/eVS47D3aMNceAtz9gQ1jGqOFXdOu/9Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvwxNofssmFAdEnlwIYV/eL5fGPF4QtcON+b3JTIqXiIk7l6wyVogoqyuItIc4LGsKXMYMr5eMIqqnb4JIavQ4306GpP4FXHoHTx8RVJN7x4MIY4plLKEE0yUxxMSsrEFtXiqVD+OmdxRLqSKwbix8KeKnuMzpPVhSyNfmwsBSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pi50xVzd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pi50xVzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65386C4CEE4;
	Thu, 17 Apr 2025 18:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913679;
	bh=w/UYUyLGfg/eVS47D3aMNceAtz9gQ1jGqOFXdOu/9Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pi50xVzdgLQrLotKGBfG9tl0BuuSpfDOxM4KXedugbqj2lUniXKofeiMezc+f/wfm
	 1OxlTRLZByCyEbxVof7adRK4rrDmSlL8EvBlKJgBpyMmati8/ZV+AHIFexrE8DHHO7
	 18wn1W0j8C7JiKUMUESOx4nRX94d5ryi/CIFHIKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 6.14 417/449] ntb: use 64-bit arithmetic for the MSI doorbell mask
Date: Thu, 17 Apr 2025 19:51:45 +0200
Message-ID: <20250417175135.080069293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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
@@ -1353,7 +1353,7 @@ static int ntb_transport_probe(struct nt
 	qp_count = ilog2(qp_bitmap);
 	if (nt->use_msi) {
 		qp_count -= 1;
-		nt->msi_db_mask = 1 << qp_count;
+		nt->msi_db_mask = BIT_ULL(qp_count);
 		ntb_db_clear_mask(ndev, nt->msi_db_mask);
 	}
 


