Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1411C30BF68;
	Mon, 13 Apr 2026 16:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098502; cv=none; b=Wj3mxwm6O8DddEL5whJuyFEI2K1Aw6q5r3EexYMLxO4tGgVFIdT4jf3M/oHVPih2zcBk+rBedaz8JlWibhEUwLqZfxm/FCR0K+SdGn+aNIfsv1ZF+iH+bLoXmuI4NNJLUwbVwFIkoqjWMgAder0gICHL1v06zcfGXkwwEWLKARY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098502; c=relaxed/simple;
	bh=gutzhQ7G3iiAfJoxRZN9IlE4JWwbT+OB05duyavQTq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGYTM0zHStB2L1WBYppEdlHvrQsUSw8Xjqp0UNFhjYfrCY8ujjDlOBacmkjgZY0pvc6m/tOvOFReJ6bfGbJVniflJGDRZoxVfIzrN9NRo3PwETCOhlRyzr3GnBfr/YOlsD497LaDpNNEY6yCc8Pg96KVwt/O+vE8n7TJSDDTsvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFH4TFzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFH4TFzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E526C2BCAF;
	Mon, 13 Apr 2026 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098502;
	bh=gutzhQ7G3iiAfJoxRZN9IlE4JWwbT+OB05duyavQTq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFH4TFzc7esbzi5z9R6N9ih71Aenn05qOsdJzF3Dz9SfFE8rwrqTQpCOwdNkXeSUh
	 glVq1NfjbaIJ5ush4SEuvY+HheOMmVXY8FvGYkbXI9TpdYFs06zDguc57mxB1aB8Z6
	 WRq2kkAy5nOc/qP9o2eu4TUSnTWDn4TGw2ldYQ3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GuoHan Zhao <zhaoguohan@kylinos.cn>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 542/570] xen/privcmd: unregister xenstore notifier on module exit
Date: Mon, 13 Apr 2026 18:01:13 +0200
Message-ID: <20260413155850.749689425@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: GuoHan Zhao <zhaoguohan@kylinos.cn>

commit cd7e1fef5a1ca1c4fcd232211962ac2395601636 upstream.

Commit 453b8fb68f36 ("xen/privcmd: restrict usage in
unprivileged domU") added a xenstore notifier to defer setting the
restriction target until Xenstore is ready.

XEN_PRIVCMD can be built as a module, but privcmd_exit() leaves that
notifier behind. Balance the notifier lifecycle by unregistering it on
module exit.

This is harmless even if xenstore was already ready at registration
time and the notifier was never queued on the chain.

Fixes: 453b8fb68f3641fe ("xen/privcmd: restrict usage in unprivileged domU")
Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260325120246.252899-1-zhaoguohan@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/privcmd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1068,6 +1068,9 @@ static int __init privcmd_init(void)
 
 static void __exit privcmd_exit(void)
 {
+	if (!xen_initial_domain())
+		unregister_xenstore_notifier(&xenstore_notifier);
+
 	misc_deregister(&privcmd_dev);
 	misc_deregister(&xen_privcmdbuf_dev);
 }


