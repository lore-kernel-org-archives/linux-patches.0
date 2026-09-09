Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F2756C621;
	Wed,  9 Sep 2026 14:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964189; cv=none; b=k900tpAEhJeS/sRCkL6FDLQES2XyrFfyXIGTt3R5ssSZFyLVITvwcZq9ZohphToIG8jJIFJDQkzbah/T0XMvqtAvzXrvlYjrgXJXemvF/LS7iIGtmyLXLpNoFHk1fAy34VB40/HnrAXUekKoS/+SAkd2jk9nJim65xuroXR5nr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964189; c=relaxed/simple;
	bh=oS4/Ie4rdrFJFPOiNV0Aou0iMLV0HOy74h1PeUFscb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEcShHf1VTKzcSFIlM/RqqsqyPPrTWje0k9yycHSYgG75OxQulUG5PTx7/rXxFLdIq6YMqJ44ce3r+2/76AkFM2TFuAEd1S+shUz+6qU/bH4qRpcIhwakO2Y+NL2WYbuMZFGeErYB8b+m3YAdF1xdKqKGC4KLTR73HmLCrnmCOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OKkSnhD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OKkSnhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE7F1F00A3A;
	Wed,  9 Sep 2026 14:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964188;
	bh=OYog3aAQ3EaMY5N/inSkfvemlRF4VbKhTbfaOlvvGtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OKkSnhD1AkIq04Uw1D8suAmT1CsA0moj8buakC2t4k5F49uTqQodHsERrMe5E9C4
	 hGQrSTp7AuDC/3IWmUxVZHsvgdBssHLwhEOgHyqXEwqx9/dmlH5RnVaLXfqySc1TPe
	 3b1EW9hqLlGp4J0qYxBNis4QmGRWS/oz0CHKBv9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 337/583] scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
Date: Wed,  9 Sep 2026 15:40:22 +0200
Message-ID: <20260909134249.670721495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit b7368687e3d11f51392d3c4774ec0263d5fbf31f upstream.

qla2x00_dfs_fce_write() called kstrtoul() with a NULL result pointer,
so a successful parse would dereference NULL and oops. Worse, the int
return value (0 on success, negative errno on failure) was assigned to
the unsigned long enable flag, inverting the intended logic: a valid
number was treated as "disable" while a parse failure enabled FCE.

Parse the value into enable and propagate parse errors to userspace.

Fixes: 841df27d619e ("scsi: qla2xxx: Move FCE Trace buffer allocation to user control")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-10-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_dfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -510,7 +510,9 @@ qla2x00_dfs_fce_write(struct file *file,
 		return PTR_ERR(buf);
 	}
 
-	enable = kstrtoul(buf, 0, 0);
+	rc = kstrtoul(buf, 0, &enable);
+	if (rc)
+		goto out_free;
 	rc = count;
 
 	mutex_lock(&ha->fce_mutex);


