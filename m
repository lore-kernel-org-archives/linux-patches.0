Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EB72253B0;
	Mon, 23 Jun 2025 21:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715193; cv=none; b=qQqEb9xHOg1Mfltfs3pEEJllC9atR5VDFnh51UA3vdVlvKC96hN3p6NP4C3Sn8WAk76ZvwDLc44ft05sK2rLUzbDto5J/8VBao2IHr4jY3oPQZbCx1zX35zgzdVEIit8C+ITiIdXuSa2VGcs6Z761tnZIYhuCVKkkQ/2RpI1DEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715193; c=relaxed/simple;
	bh=Ml12dc+ib7BucN+WZnDE8emFO1KpI1AshJmthd7KEhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WysPU5676N6dOVAsD0aJPHLebfwjOrCG7D/bRUlJ75BcK6aNnCe4uAHqYX4hJOaoUQRhmHm/BVNizqxy5wTSeNs0lBwc4Ct9YZGp8kgMgxknDCCJ18I/uEEgAu0kd9TnFVjpXTX4P3dclNG1ab3ogYLwstWh0Gmd6iW940nd7rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftJoYCP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftJoYCP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFFDC4CEEA;
	Mon, 23 Jun 2025 21:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715193;
	bh=Ml12dc+ib7BucN+WZnDE8emFO1KpI1AshJmthd7KEhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftJoYCP85tD+re5Xse1aFv7lr4SCkOUXUUo6YXsz6Yz2jo1gIesfYbqfwYE/s0Tb/
	 YVoWc5DmC3NkZnaRtRrpkxWi7cz+X9HfTpUm2t/iU4fEON94IjDA0Zfyz+EU052CTk
	 T5puRIt3NBA8LoJY4KKmtX06HdApNUXZ6Eabg+lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	M Nikhil <nikh1092@linux.ibm.com>,
	Nihar Panda <niharp@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.15 464/592] scsi: s390: zfcp: Ensure synchronous unit_add
Date: Mon, 23 Jun 2025 15:07:02 +0200
Message-ID: <20250623130711.465168480@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit 9697ca0d53e3db357be26d2414276143c4a2cd49 upstream.

Improve the usability of the unit_add sysfs attribute by ensuring that
the associated FCP LUN scan processing is completed synchronously.  This
enables configuration tooling to consistently determine the end of the
scan process to allow for serialization of follow-on actions.

While the scan process associated with unit_add typically completes
synchronously, it is deferred to an asynchronous background process if
unit_add is used before initial remote port scanning has completed.  This
occurs when unit_add is used immediately after setting the associated FCP
device online.

To ensure synchronous unit_add processing, wait for remote port scanning
to complete before initiating the FCP LUN scan.

Cc: stable@vger.kernel.org
Reviewed-by: M Nikhil <nikh1092@linux.ibm.com>
Reviewed-by: Nihar Panda <niharp@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
Link: https://lore.kernel.org/r/20250603182252.2287285-2-niharp@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/scsi/zfcp_sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -449,6 +449,8 @@ static ssize_t zfcp_sysfs_unit_add_store
 	if (kstrtoull(buf, 0, (unsigned long long *) &fcp_lun))
 		return -EINVAL;
 
+	flush_work(&port->rport_work);
+
 	retval = zfcp_unit_add(port, fcp_lun);
 	if (retval)
 		return retval;


