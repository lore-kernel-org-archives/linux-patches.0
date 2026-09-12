Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83C42F8EAE;
	Sat, 12 Sep 2026 14:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222092; cv=none; b=J4U4sfjB0fZ2K8D5oBlLozI9pGby/EA3PZakFWWHWIR8h3dvxuLzljVByi01rj6mPRTk5LmGOw69wzZ6WUrZpgQ6emyytkiZMnoKX5wqELTNb3Q3wjZFVZCrlCtkAOSyqJEK7fA5fudIv1qzAEIihW4MgSfJ1Mgx9d8SAC3PZZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222092; c=relaxed/simple;
	bh=n7W5f7bTFbKEnODKTCy+z7NexZNi6MmuJC1LInE0X10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3MIktMIm3zU5kYXVnBsSiMW2LrfEsf1aPU83ZHbje5tt+Ko1C8LdKnrC6VOly5uiCWfyFcMfyuFwfDGeB0pH+WSL0akkulNOHNXXHYeBaUhnZda+wm70hgPxcQVz8xmDQb5too8y8SZrJP/MKqQRgoZrDOcpEFnAsaGkbDwnv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAx+s5AP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAx+s5AP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC1E1F000FF;
	Sat, 12 Sep 2026 14:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222090;
	bh=tIjQjU+Vb1MS4ga48DyrKSZMBrROm5fh0Wyq8+YRLsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAx+s5APh13idf1lejhakcYLz7xvLAGbzclLNhB6AT8HW6oMEDSgpIg7+6gax45ix
	 yw9+CQxdqhcpCCFftjvSuRbMIimE8t/eRSJbCLiCdsUIUl2l06rhyXwfPQS9gRmEEG
	 oFNpHBK6BaFZkiSWqqoy8KIVwC3Zye7jw5fltaik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+916c888ba5f1a54c9526@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 6.6 0517/1424] drm/gud: NUL-terminate TV mode names read from the device
Date: Sat, 12 Sep 2026 08:49:09 +0200
Message-ID: <20260912065618.869980913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 500cb24cd61bad8a2747ddfc49b7034899c82d94 upstream.

gud_connector_add_tv_mode() reads a buffer of fixed-size mode names from
the USB device and passes pointers into it to
drm_mode_create_tv_properties_legacy(), which calls strlen() on each one.
Nothing guarantees the device NUL-terminates a name, so strlen() can run
past the end of a slot and, for the last mode, past the end of the
allocation.

Terminate each name at the end of its slot before use.

Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Reported-by: syzbot+916c888ba5f1a54c9526@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=916c888ba5f1a54c9526
Tested-by: syzbot+916c888ba5f1a54c9526@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Acked-by: Ruben Wauters <rubenru09@aol.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260816085234.22053-1-kartikey406@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_connector.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gud/gud_connector.c
+++ b/drivers/gpu/drm/gud/gud_connector.c
@@ -397,8 +397,13 @@ static int gud_connector_add_tv_mode(str
 	}
 
 	num_modes = ret / GUD_CONNECTOR_TV_MODE_NAME_LEN;
-	for (i = 0; i < num_modes; i++)
-		modes[i] = &buf[i * GUD_CONNECTOR_TV_MODE_NAME_LEN];
+	for (i = 0; i < num_modes; i++) {
+		char *mode = &buf[i * GUD_CONNECTOR_TV_MODE_NAME_LEN];
+
+		/* The device is not trusted to NUL-terminate the name */
+		mode[GUD_CONNECTOR_TV_MODE_NAME_LEN - 1] = '\0';
+		modes[i] = mode;
+	}
 
 	ret = drm_mode_create_tv_properties_legacy(connector->dev, num_modes, modes);
 free:


