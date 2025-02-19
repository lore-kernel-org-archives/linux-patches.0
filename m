Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D111DE2C5;
	Wed, 19 Feb 2025 08:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954377; cv=none; b=ZQtm7o2mML/3rkwdb/6kFFiullgeqKtpg+Kyq9VDf3OJejwbLqp1tE04rmJFg7DZUs4Fmh05E+Rbmx9sh5MOv6+DbUVwx7HCsS3pBRRZsBRq+Gezxei42E5ELU6L/Y8uwB1bpyDGqNmGHjR0P5KoW47YHXnj4uow6qWQ3FOCEO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954377; c=relaxed/simple;
	bh=h4umBKjNZRrJYrmbrO4TbhEv6kqppccUt+VZsuvxuzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oUtdGtRbVhv1FBuf2iomvnAtshcDA+ugQc4osYkO+4q6ETVzutTRe9gMGeoFcdp70L0RQfDn6ajQwv2TvLfagSAo88w9HatAXi2vl7BHc62PcFbjqwMRdYqnR8ZmGVWfigob1xlE6o27TtjIbeYRvaI+opybGsVd4dP4c2zmSJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZw5/aWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZw5/aWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D08C4CED1;
	Wed, 19 Feb 2025 08:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954377;
	bh=h4umBKjNZRrJYrmbrO4TbhEv6kqppccUt+VZsuvxuzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZw5/aWJs+emPSuumB9H5+/1HK4H1J/zVSpCo7F1fvzyLroC65jWucO50aAT9Rva9
	 Fc0xQXWzR3TRWrX23Ag9i0DdIJUw3JMRubMmmgka7ZKilCRXerUPLTwc+D9w/D/EJ9
	 g3w7MhsmuShqIedcUu60EmSF8VNWFa0l57uRMeqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.13 186/274] ptp: vmclock: Set driver data before its usage
Date: Wed, 19 Feb 2025 09:27:20 +0100
Message-ID: <20250219082616.864535832@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit f7d07cd4f77d77f366c8ffbb8ba8b61f614e5fce upstream.

If vmclock_ptp_register() fails during probing, vmclock_remove() is
called to clean up the ptp clock and misc device.
It uses dev_get_drvdata() to access the vmclock state.
However the driver data is not yet set at this point.

Assign the driver data earlier.

Fixes: 205032724226 ("ptp: Add support for the AMZNC10C 'vmclock' device")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_vmclock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ptp/ptp_vmclock.c
+++ b/drivers/ptp/ptp_vmclock.c
@@ -525,6 +525,8 @@ static int vmclock_probe(struct platform
 		goto out;
 	}
 
+	dev_set_drvdata(dev, st);
+
 	if (le32_to_cpu(st->clk->magic) != VMCLOCK_MAGIC ||
 	    le32_to_cpu(st->clk->size) > resource_size(&st->res) ||
 	    le16_to_cpu(st->clk->version) != 1) {
@@ -589,8 +591,6 @@ static int vmclock_probe(struct platform
 		 (st->miscdev.minor && st->ptp_clock) ? ", " : "",
 		 st->ptp_clock ? "PTP" : "");
 
-	dev_set_drvdata(dev, st);
-
  out:
 	return ret;
 }


