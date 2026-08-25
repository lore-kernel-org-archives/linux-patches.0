Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EA5481672;
	Tue, 25 Aug 2026 13:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666169; cv=none; b=d7qK2DtObp4J0S0sgiK4V3ybRv0QrtLw9TJ9hto/W6M4XB0dLA7IK9exihTaBsbqHfis08PqIXQxURhD6XCcKMU8DvpzACBWSR3kFekSpgtK31hrMsdXIrovzq5mEx8dApdEFTeOUL+Gyt6cTk8cPphEJ30nM3REqmeNIRc6NrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666169; c=relaxed/simple;
	bh=9NU3qBNrb8x9FmTwm2nBYgpC13mvzpNVxwxIDH0U58g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWIMyaQZDI0uGiaOKFRVEmzlPhGRMcSOMTqrBil4ZluKh6zg76GiPZryZuA63VWoCWbzOjNLb8/z+QazoNGzgrIEmYqpUNCxgZASzQtW18sh+W5QtMeHEE290dDxFjAv4WWOCf1fPgbK2CUWnu+MmABhlsAA1Cf+VykG9UNcDTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYkJM2c3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYkJM2c3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4E81F000E9;
	Tue, 25 Aug 2026 13:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666168;
	bh=nHHw9Qb+yV/asqlt1FcIdhFA8nfC6d+ziyVEnDHYMmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYkJM2c3+p9hG666+kradVIW8T8fbjxUqMzuuQcAlMRevrX10/86zov8T1sgD71Q4
	 tErH52vmjz/Srghl71vnKlSOdkZvAAOV6hzg7xtnj68ipTK2NbYmOB2yW+tAEnoEUf
	 9U4PIvnMPj0rWl29G9TyBLJyUP3CR0UD7odcEGqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/76] s390/vfio_ccw: Cancel existing workqueues
Date: Tue, 25 Aug 2026 15:26:20 +0200
Message-ID: <20260825132542.617623684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 79c60b2c61105368dcc8444eb45847e21734f7c4 ]

The initialization of the io_work and crw_work workqueues begs the
question of whether they should be un-initialized. Add the corresponding
cleanup tags in _release_dev to ensure work isn't dispatched after
the private struct is free'd.

Suggested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Fixes: e5f84dbaea59 ("vfio: ccw: return I/O results asynchronously")
Fixes: 3f02cb2fd9d2 ("vfio-ccw: Wire up the CRW irq and CRW region")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
[ dropped the `vfio_ccw_mdev_release_dev()` hunk since 5.15 lacks the embedded `vfio_device` release callback, keeping only the `close_device()` drain ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_ops.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -207,6 +207,14 @@ static void vfio_ccw_mdev_close_device(s
 	}
 
 	cp_free(&private->cp);
+
+	/*
+	 * Ensure these work items are drained, in the event the
+	 * device is re-opened instead of released.
+	 */
+	cancel_work_sync(&private->io_work);
+	cancel_work_sync(&private->crw_work);
+
 	vfio_ccw_unregister_dev_regions(private);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 				 &private->nb);


