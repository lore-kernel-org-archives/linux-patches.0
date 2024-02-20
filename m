Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B947614A4E6;
	Tue, 20 Feb 2024 21:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464603; cv=none; b=Dz7vqaznigV9tLjBO7klFyKlJeVcU7bPhpNQtNrNeuS7ahdmRcfWyiFEoovKMd/My4CM3HvuKpgFOdUqjQRd/BvIAZZXzi5e4Hb4SYLtxfjOvnwhVSszO8tbq2qf94Ek5CQx/z0fWWfbpeuj0l+nCJOl2gWL3lkJDd7M13hvY2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464603; c=relaxed/simple;
	bh=00TqylvyRWTS9gLKE5sZ6RkVUIsZ2ipitEbA6PKSvu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nh4neWIurXhmgJKbMECq4ev+hY+Fr8PkcsCDk8BRf7IPHauP/5nWvVD3w3cx57wvXqKWXbObrdFlHe756CmiNFptJreEwE88O5Rrj2Ty7MbWbIenjaO7wdW0DWki3MQ8L6sE+L0eF0TU+4LGb2FucAEbNor/6nr4Y8SLNDTHhEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfaLu2By; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfaLu2By"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A41C433F1;
	Tue, 20 Feb 2024 21:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464603;
	bh=00TqylvyRWTS9gLKE5sZ6RkVUIsZ2ipitEbA6PKSvu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfaLu2ByDhu+6vVsDU9VzuDSwHCiNCDLzfNfuUSEiDa6iz/hw3v2PRG2OdteGhl8D
	 Mr+relgqJx3Xj/aO0eM3yINf9R/poSO5yRY+pyh07aTynlk2CAY+RTopQ9+jUTwevU
	 do69WWfOSjGyZNNgRnMakKCupvcVbynYoen80/5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.7 078/309] parisc: Prevent hung tasks when printing inventory on serial console
Date: Tue, 20 Feb 2024 21:53:57 +0100
Message-ID: <20240220205635.644151716@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit c8708d758e715c3824a73bf0cda97292b52be44d upstream.

Printing the inventory on a serial console can be quite slow and thus may
trigger the hung task detector (CONFIG_DETECT_HUNG_TASK=y) and possibly
reboot the machine. Adding a cond_resched() prevents this.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/drivers.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -1004,6 +1004,9 @@ static __init int qemu_print_iodc_data(s
 
 	pr_info("\n");
 
+	/* Prevent hung task messages when printing on serial console */
+	cond_resched();
+
 	pr_info("#define HPA_%08lx_DESCRIPTION \"%s\"\n",
 		hpa, parisc_hardware_description(&dev->id));
 


