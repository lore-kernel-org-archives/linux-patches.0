Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3577764E;
	Mon, 15 Apr 2024 14:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191083; cv=none; b=K4u+IMJafFj0ieA5URObTEdMkILFdno9fHtZj86Vq49d9e39j4Gnm5HdJ3tp+xKb6R6oufReVcgz58z6/xGB5cW6ug5xTtrORDo0YGSiayEZp628jTTcCK82haGyFQoICRcUwQ0coPRl8JQEJgFaXqFT4c0lFjFySutmyLqId3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191083; c=relaxed/simple;
	bh=31OkMvRHlzM2LaLACPPOggOD+x8RC/10o+jlKyCq64w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3RTYA+w0vo/17xtmmPfGvNnuDqbBhGOOEsNfxQj1YiwUWSXgZC19ItJLBSSVbGgLD6v5LdbtkHRs7bNATaa/Bd47RzacPB+xg6FqXkxsitIc3eSF2qNXPW5XFiv4G9u1Q+uqv0V1DCV+0LSSjtJslxE4DCzkE0dWK/lSXI+GbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rq9eKAn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rq9eKAn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB8DC113CC;
	Mon, 15 Apr 2024 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191082;
	bh=31OkMvRHlzM2LaLACPPOggOD+x8RC/10o+jlKyCq64w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rq9eKAn2T5JNacapt7po4NPQGIwZxEw1/mZ7fXA0z1h78IZOAI7COhsjYG9XmfT/d
	 OV9LqaOOHXHhSMB8CgVFdgyP+81aeHud/evLN1MsHPuzA9xEEtmx9so8KIsyu6zw6a
	 NqKm+/gGy+dpn8E93SNmrAk4F5R6gqUcDnQbx6rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 027/172] firmware: arm_scmi: Make raw debugfs entries non-seekable
Date: Mon, 15 Apr 2024 16:18:46 +0200
Message-ID: <20240415142001.172900890@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit b70c7996d4ffb2e02895132e8a79a37cee66504f ]

SCMI raw debugfs entries are used to inject and snoop messages out of the
SCMI core and, as such, the underlying virtual files have no reason to
support seeking.

Modify the related file_operations descriptors to be non-seekable.

Fixes: 3c3d818a9317 ("firmware: arm_scmi: Add core raw transmission support")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20240315140324.231830-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/raw_mode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/raw_mode.c b/drivers/firmware/arm_scmi/raw_mode.c
index 3505735185033..130d13e9cd6be 100644
--- a/drivers/firmware/arm_scmi/raw_mode.c
+++ b/drivers/firmware/arm_scmi/raw_mode.c
@@ -921,7 +921,7 @@ static int scmi_dbg_raw_mode_open(struct inode *inode, struct file *filp)
 	rd->raw = raw;
 	filp->private_data = rd;
 
-	return 0;
+	return nonseekable_open(inode, filp);
 }
 
 static int scmi_dbg_raw_mode_release(struct inode *inode, struct file *filp)
@@ -950,6 +950,7 @@ static const struct file_operations scmi_dbg_raw_mode_reset_fops = {
 	.open = scmi_dbg_raw_mode_open,
 	.release = scmi_dbg_raw_mode_release,
 	.write = scmi_dbg_raw_mode_reset_write,
+	.llseek = no_llseek,
 	.owner = THIS_MODULE,
 };
 
@@ -959,6 +960,7 @@ static const struct file_operations scmi_dbg_raw_mode_message_fops = {
 	.read = scmi_dbg_raw_mode_message_read,
 	.write = scmi_dbg_raw_mode_message_write,
 	.poll = scmi_dbg_raw_mode_message_poll,
+	.llseek = no_llseek,
 	.owner = THIS_MODULE,
 };
 
@@ -975,6 +977,7 @@ static const struct file_operations scmi_dbg_raw_mode_message_async_fops = {
 	.read = scmi_dbg_raw_mode_message_read,
 	.write = scmi_dbg_raw_mode_message_async_write,
 	.poll = scmi_dbg_raw_mode_message_poll,
+	.llseek = no_llseek,
 	.owner = THIS_MODULE,
 };
 
@@ -998,6 +1001,7 @@ static const struct file_operations scmi_dbg_raw_mode_notification_fops = {
 	.release = scmi_dbg_raw_mode_release,
 	.read = scmi_test_dbg_raw_mode_notif_read,
 	.poll = scmi_test_dbg_raw_mode_notif_poll,
+	.llseek = no_llseek,
 	.owner = THIS_MODULE,
 };
 
@@ -1021,6 +1025,7 @@ static const struct file_operations scmi_dbg_raw_mode_errors_fops = {
 	.release = scmi_dbg_raw_mode_release,
 	.read = scmi_test_dbg_raw_mode_errors_read,
 	.poll = scmi_test_dbg_raw_mode_errors_poll,
+	.llseek = no_llseek,
 	.owner = THIS_MODULE,
 };
 
-- 
2.43.0



