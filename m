Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248C2347532;
	Fri,  4 Sep 2026 05:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499863; cv=none; b=Z+uYNjY8h7JHuRiNTFX/9fGtmSZKa461jJxda/PVH0QSV6svNOXYo9mlRKBNKDS3t+E+eobhyMrZWMnd5gU/lxrP09z/DKr/D5bTrHOnSVlupsVoWj7kb/XqTII2NeiiKYGqealVIoSoTwHDFeWywCJMLuMHHL+tyE3JKw65ksg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499863; c=relaxed/simple;
	bh=04wSfrk+joWwbHuiAVjcC/qGDXGKJ3WWFqeHGPDgCsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KYVSCXu4d0zFbPtw9J/BmMsOPJmpZLti4ucANU0M818Rt8NqM3/wO9QDShb5/O5Jag7aVdMu+wMNg743iEBClkiKbZyZm9dQaQ4WV1cose02Fiip5MSsFby9uSpZidECHc423Xxxko3qeFXK9nbRIr63/u2BuKGJSkwkIwu8RJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ahx/fmbS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ahx/fmbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744F11F00A3D;
	Fri,  4 Sep 2026 05:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499862;
	bh=bwPVVbe1fyILA20M48hzNj0G240bwyP71YdXQFpqBG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ahx/fmbSMGNNRtejjIoEuiTHlsjDyoeM1GngFgt39VQNhuhyhVJDxB2+w2zbCO9Tg
	 OZvJpbfpvXpBC1z/av+MzyseyeE7vZ07G4yv0Vm/ctoWBH1BM088dntz5gL2ZheTPu
	 e4TJxAMN35v9q3IqnKG61W8mz3cxvm/VyZCIne+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hilgad Montelo <hilgad.montelo@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 567/713] platform/x86: panasonic-laptop: Fix sentinel write past pcc->sinf[]
Date: Fri,  4 Sep 2026 06:58:55 +0200
Message-ID: <20260904045816.528114090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hilgad Montelo <hilgad.montelo@gmail.com>

commit 329f10d8be193bf36af124e00b9dd6644cd71724 upstream.

acpi_pcc_retrieve_biosdata() rejects SINF packages only when
pcc->num_sifr is strictly less than hkey->package.count, then
unconditionally writes a trailing sentinel at
pcc->sinf[hkey->package.count]. But pcc->sinf[] is allocated with
exactly pcc->num_sifr elements (valid indices 0..num_sifr-1), so that
write needs num_sifr strictly greater than package.count to stay in
bounds -- num_sifr == package.count passes the existing check but
still overflows by one element.

This is exactly the case probe()'s existing num_sifr++ workaround
("Some DSDT-s have an off-by-one bug where the SINF package count is
one higher than the SQTY reported value") is written to accommodate:
when a DSDT's SINF package count equals SQTY+1, the workaround makes
num_sifr equal to package.count, which is precisely the boundary that
overflows here. Found via UBSan (array-index-out-of-bounds) on
hardware where HKEY.SQTY returns 37 and HKEY.SINF()'s package has 38
elements: num_sifr becomes 38 after the += 1 workaround, the loop
correctly fills indices 0..37, and the sentinel write then targets
index 38, one past the end -- a silent 4-byte heap overflow on kernels
without CONFIG_UBSAN.

Tightening the rejection check to num_sifr <= package.count would
avoid the overflow but breaks probe() entirely on exactly this
hardware, since num_sifr == package.count is the case the off-by-one
workaround exists to support. Nothing else in the driver reads this
sentinel value back, so simply skip the write when there is no room
for it instead.

Fixes: a3d0dbd18ce9 ("platform/x86: panasonic-laptop: simplify allocation of sinf")
Cc: stable@vger.kernel.org
Signed-off-by: Hilgad Montelo <hilgad.montelo@gmail.com>
Link: https://patch.msgid.link/20260813221744.25668-4-hilgad.montelo@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/panasonic-laptop.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -360,7 +360,16 @@ static int acpi_pcc_retrieve_biosdata(st
 		} else
 			pr_err("Invalid HKEY.SINF data\n");
 	}
-	pcc->sinf[hkey->package.count] = -1;
+	/*
+	 * pcc->sinf[] has pcc->num_sifr elements (valid indices
+	 * 0..num_sifr-1). On DSDTs where SINF's package count equals
+	 * num_sifr exactly -- the off-by-one case probe()'s num_sifr++
+	 * already allocates a spare element for -- there is no room left
+	 * for this trailing sentinel; nothing reads it back, so just skip
+	 * the write rather than running one element past the flex array.
+	 */
+	if (hkey->package.count < pcc->num_sifr)
+		pcc->sinf[hkey->package.count] = -1;
 
 end:
 	kfree(buffer.pointer);


