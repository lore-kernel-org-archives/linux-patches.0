Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806CA78B60;
	Wed, 21 Feb 2024 14:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525691; cv=none; b=TKNCefcUNIcFNR9zRPrs0TGPG+9+HlVUMn9jPi84VeLJmzT6g16WtMMqcWPpgtz+3TiCpAPhS7n9W6ZZmCUa119JD8QY28iC8E+Qqx5i66R9Jj8+DOpkcr0G6wDwpqcS0TCqdXcPXY8GSJ4tPVilbAFcj5Vozf21ueO0z+h3XXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525691; c=relaxed/simple;
	bh=2dDGxrexVWfW+YyfaxKpHONvlf7yP1eyHRB5SPzkHR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrlAAesiPUwQpwlEaqXtyoPP1IllQmdQl2yWWVBxXF5TbLSRr7Jml7PNGfk3LsK37Dj7fIuFVxtXLKO8sJyyLw/POmBgzSeqU9XWhGFJAu+vpWET/+VPSAz2H55RFO5d3nDKBlYfdlyWdo4JwhUPfs9es5TFvmnl1fEi/Ej00io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2aii2VG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2aii2VG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFF8C433C7;
	Wed, 21 Feb 2024 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525691;
	bh=2dDGxrexVWfW+YyfaxKpHONvlf7yP1eyHRB5SPzkHR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2aii2VG04qb+YIEzewNuTUqjX11YVzQ+6aVGp4D9YNDNFUJ1JrQ5xDM3gqjH+MEx
	 u+JJfFwyCmmr1VQCyAgGjBG3YKmdSlAzEaohVE5CLAGrsmhoJQb4TOTt3CZ9yzTFYn
	 DlqkSOCRDTvPCIQ/+Zq1mQutRBg/rZHWKKgUCLZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 5.4 234/267] serial: max310x: set default value when reading clock ready bit
Date: Wed, 21 Feb 2024 14:09:35 +0100
Message-ID: <20240221125947.601455019@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 0419373333c2f2024966d36261fd82a453281e80 upstream.

If regmap_read() returns a non-zero value, the 'val' variable can be left
uninitialized.

Clear it before calling regmap_read() to make sure we properly detect
the clock ready bit.

Fixes: 4cf9a888fd3c ("serial: max310x: Check the clock readiness")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240116213001.3691629-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -610,7 +610,7 @@ static int max310x_set_ref_clk(struct de
 
 	/* Wait for crystal */
 	if (xtal) {
-		unsigned int val;
+		unsigned int val = 0;
 		msleep(10);
 		regmap_read(s->regmap, MAX310X_STS_IRQSTS_REG, &val);
 		if (!(val & MAX310X_STS_CLKREADY_BIT)) {


