Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DC54F3EAA;
	Wed, 30 Sep 2026 17:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787787; cv=none; b=iI9/WQ14IUCkKGXcovbymKPEzdvhj2YAKtLNQXZPkVnERK6R7imWVGEMSE1hOBE7jazxJqjMlUMLl5lgs4q4o/WpYocjru009vSqayrladL1L2qOZkh1u6l7ojhkRl76tuoqv+ZA9SnFvSr4FQ3MHF0KYpvALQ8iG7yCB0cE1z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787787; c=relaxed/simple;
	bh=4Q3kvogHEpCaQTNg6Eu0l3B2jk3EFn5F/O0TabxKMWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nxb/xFTlJBaOnXOXtgUJAJUoy7fwHS6jomdk31NO2id/XC/bXiptKBegINX5/TlFWsTb78kTynXkjEBPRTsOPz4eIAgFzInrx/DiXAViBdabGoEWD6pfQANB9n7FTO1wnRM1UuOT3O4dFcUfPvdYtALH2KrrWrmzXjZZNqk5O68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yp3KxXmU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yp3KxXmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582AA1F000FF;
	Wed, 30 Sep 2026 17:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787785;
	bh=opcARfy7expPmJFrDvBrgCZtGEHKPZoH1nYx1Vh15A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yp3KxXmU26Ddoosm83RT+LNWStkaQoJLL/YVaGYsJXtGx7dmfaO1gSIWkuokU/rHE
	 0VC4s7TvCnvzY0kGa0SnYVHZ+wv6z9NBpcEF3Fy1+eYALo2A0AM55rPBzR8oBwlGw+
	 dXTvCRjx9IhIc7mGSI40HB/E4TZHd+CD9ncb5D3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Ojha <abhishek.ojha@savoirfairelinux.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 346/457] net: phy: micrel: Advance register data pointer in write loop
Date: Wed, 30 Sep 2026 17:27:31 +0200
Message-ID: <20260930152353.480161469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Ojha <abhishek.ojha@savoirfairelinux.com>

commit 95c4d54ed02283e9a09e8cd7360e384daa67a741 upstream.

lanphy_write_reg_data() does not advance the data pointer while iterating
over the register table. As a result, it writes the first entry num times
and leaves the remaining errata registers unconfigured.

Single-entry tables are unaffected, but tables with multiple entries
leave every entry after the first unapplied.

Advance the data pointer after each successful write so every table entry
is applied in order.

Fixes: c8732e933925 ("net: phy: micrel: lan8842 errata")
Cc: stable@vger.kernel.org
Signed-off-by: Abhishek Ojha <abhishek.ojha@savoirfairelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260916231928.1336305-1-abhishek.ojha@savoirfairelinux.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -6285,6 +6285,7 @@ static int lanphy_write_reg_data(struct
 					    data->val);
 		if (ret)
 			break;
+		data++;
 	}
 
 	return ret;


