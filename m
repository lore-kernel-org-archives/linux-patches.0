Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E1B2EAE5;
	Thu, 11 Apr 2024 10:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830706; cv=none; b=Ncc6sKpwNQvM1labAdm/+1BRC1yAs1oMXmDmMRWSrBkpHoI/iil9pOivluTwy+1LHC8tNw9pbzGS7ddrxbfZGdKzSmDpgCeQ4kFAFhkqMlCu/aIHigPpcu6sB5BN1zhZSKfips9dDW6l4nETIl6ZGsGZEKAgRisAyodpEu7/Qbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830706; c=relaxed/simple;
	bh=Az+xdoN7RAbH9KXSDloEMmYqakirdLnTHBUwq0dn6B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ps32wQZj76kW5/A8leYYr7uDmqbdWkAuy/1/nBvBIT627EqMpD/bKug7lL/ZR1pUgaKsqlwEnaG6oqFS1y/nn90Fwxhox575FIalmjee9hyoRJ0EQpefcS2Cterh+t9TVichxmT+F5Mib5QZU/bA0ovqAgZ7KAiwPkj2XO0osbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ya2G0yyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ya2G0yyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561F1C433C7;
	Thu, 11 Apr 2024 10:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830706;
	bh=Az+xdoN7RAbH9KXSDloEMmYqakirdLnTHBUwq0dn6B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ya2G0yyhAHvaiFQaleNM/DLHGXCodbCPvzPMnxGnBsBUvy8baDqNWUKzrSkff1mg6
	 dheKBYBRyhJjhoNscj4sDRLvqy4n8hiHT/mibJ1+ZFf/N0CAftiUn5yN8Sp4AhBOv2
	 UXUGxZHODEiMs27GAAiDuriPRb+HXowOlPjjrhr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <nico@fluxnic.net>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 090/215] vt: fix unicode buffer corruption when deleting characters
Date: Thu, 11 Apr 2024 11:54:59 +0200
Message-ID: <20240411095427.609005595@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nico@fluxnic.net>

commit 1581dafaf0d34bc9c428a794a22110d7046d186d upstream.

This is the same issue that was fixed for the VGA text buffer in commit
39cdb68c64d8 ("vt: fix memory overlapping when deleting chars in the
buffer"). The cure is also the same i.e. replace memcpy() with memmove()
due to the overlaping buffers.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Fixes: 81732c3b2fed ("tty vt: Fix line garbage in virtual console on command line edition")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/sn184on2-3p0q-0qrq-0218-895349s4753o@syhkavp.arg
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -405,7 +405,7 @@ static void vc_uniscr_delete(struct vc_d
 		char32_t *ln = uniscr->lines[vc->vc_y];
 		unsigned int x = vc->vc_x, cols = vc->vc_cols;
 
-		memcpy(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
+		memmove(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
 		memset32(&ln[cols - nr], ' ', nr);
 	}
 }


