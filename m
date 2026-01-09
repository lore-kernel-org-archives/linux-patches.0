Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3237135CB68;
	Fri,  9 Jan 2026 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962414; cv=none; b=sGbSRwKmXwPA4ZrITu1vetxbPbDkShCf16upIFopTFsWlsLWyFUkE0pmR3N4q17cQLH3xSrDgdJ3HwFhITPp3tNR1eNrao0xaNuS07t5F3xA55aoQe2NFojpPnXu65AfC2AMi2RJyRiCzkoCAcaw5yUHy6otO6Bk8LE36pa2/1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962414; c=relaxed/simple;
	bh=oYQAxX+ujCuLQVAHNXebUNdL2Qo6KoVMuI27NL7BZF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGo1B2tLk1BaHTQQj4bGQLQ58IETZQJvYuHKTb9G/IyLaXNxHSlAx9v7jO6AM/j5VwwSrg0JteHA0s8S0dU6BrFRj38pNIEShkh45FKAEYfC/owClQvuJPqjFYxJG8EDGnRF28gntrATef6A0YDnULdW2Thh/sGACTuHt+2qqCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Luz3m4LH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Luz3m4LH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645E1C19421;
	Fri,  9 Jan 2026 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962413;
	bh=oYQAxX+ujCuLQVAHNXebUNdL2Qo6KoVMuI27NL7BZF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Luz3m4LHowN227rekNPSz0PHvcmErY3e3sJ0X0wwpmkJ0V2d8mnxm3bkSwTBaO2qX
	 OFZQoFr2owBWcKvHSwp6CSfjTwavfW2m8XzCjkyDnclybBAwy6rmQcKut/TUtENasn
	 o5IDO1gni9EjUfYimP/GST3pzs+W91oUf6gFSymw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 357/634] parisc: Do not reprogram affinitiy on ASP chip
Date: Fri,  9 Jan 2026 12:40:35 +0100
Message-ID: <20260109112130.957698496@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit dca7da244349eef4d78527cafc0bf80816b261f5 upstream.

The ASP chip is a very old variant of the GSP chip and is used e.g. in
HP 730 workstations. When trying to reprogram the affinity it will crash
with a HPMC as the relevant registers don't seem to be at the usual
location.  Let's avoid the crash by checking the sversion. Also note,
that reprogramming isn't necessary either, as the HP730 is a just a
single-CPU machine.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/gsc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -154,7 +154,9 @@ static int gsc_set_affinity_irq(struct i
 	gsc_dev->eim = ((u32) gsc_dev->gsc_irq.txn_addr) | gsc_dev->gsc_irq.txn_data;
 
 	/* switch IRQ's for devices below LASI/WAX to other CPU */
-	gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
+	/* ASP chip (svers 0x70) does not support reprogramming */
+	if (gsc_dev->gsc->id.sversion != 0x70)
+		gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
 
 	irq_data_update_effective_affinity(d, &tmask);
 


