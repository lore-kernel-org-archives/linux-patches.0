Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B92E19F43A;
	Thu,  3 Jul 2025 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554305; cv=none; b=WFlZsbxQif0ecrCUFPoRtNs+bvNqVY1mefwEbSpDfSAZlAdLCxZhIc7B+20hjPbsF2a20qgJx2UK0ZzUMCw9BdCleRbb3IzDO1HJf7ZnOljAmSVyguR4Nrt1tIHdHQNT8uz/LUn4sMoCQOx51xlC3LbVE4ed/lFLM7ysy0A/FE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554305; c=relaxed/simple;
	bh=wto0AJmF7rkKQ8wrJN0kfDn2Mg7kU47i4tkz040i1lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP0MxMY84dIQ71NVb/wGMYRBtsmafAqIV/4fr+P3y48RXMoFk3MfL1VpRDKIMTFVWEVKwMKkp8MxVSIWIrGDNf6YWMubaZ9DJboefaYddMyIPd/kkqypx7xAMl/3f0G+nD50Slk6pvbLLGkm+cjvOBu7i8WF4RUVu01FbRQLwTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7L4SWxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7L4SWxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1E1C4CEE3;
	Thu,  3 Jul 2025 14:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554305;
	bh=wto0AJmF7rkKQ8wrJN0kfDn2Mg7kU47i4tkz040i1lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7L4SWxVx4qjK3QZkCC/nGkWERqpgl6fLMYXibGAsNSssvkMJUWQZlM285Pm6aaDy
	 A1kBPWUahEacDLWhY+t7Bv3cxitIAzhvO0lD8mhC6y3vJ/E/hAxHyRerur3FIUcr6h
	 u/KlJ2UcQvJXLlpkYXJj3En5qdi/cLiH8Zab5Faw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 144/218] HID: wacom: fix memory leak on sysfs attribute creation failure
Date: Thu,  3 Jul 2025 16:41:32 +0200
Message-ID: <20250703144001.882021243@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit 1a19ae437ca5d5c7d9ec2678946fb339b1c706bf upstream.

When sysfs_create_files() fails during wacom_initialize_remotes() the
fifo buffer is not freed leading to a memory leak.

Fix this by calling kfifo_free() before returning.

Fixes: 83e6b40e2de6 ("HID: wacom: EKR: have the wacom resources dynamically allocated")
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2031,6 +2031,7 @@ static int wacom_initialize_remotes(stru
 	if (error) {
 		hid_err(wacom->hdev,
 			"cannot create sysfs group err: %d\n", error);
+		kfifo_free(&remote->remote_fifo);
 		return error;
 	}
 


