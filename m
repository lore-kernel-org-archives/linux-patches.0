Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3821CA8F;
	Mon,  1 Apr 2024 16:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988414; cv=none; b=JNq4UGVAPCkRKnz+ELSpRwcGzyFerHO6wQ49QSZDMfL/J3YHpjgNFyTf2GbjcL258Y6PsmfcgFGoUv0qBiDItCnvfi8wgiHIkIuSOc8z6s9tQ3U8fA+BTzg/DHETsRJYXziJr9L5og8Zh7aI77C17qF55ubVFhhPFW8c1qnrhYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988414; c=relaxed/simple;
	bh=GpgERM70bnoUnMFiKshvQE6CDWxKYg3WtMPTOG0Y1vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpjUH8gvUwNdDlRF7eMSzhz6xq/K7LGLcnaatd3jzmpj3fguWIEJFg6AjZSyrd6j5Up6iiKGf4eSuP4zQqtfp17tV86yVC2pVINZD/9NRDbXAtXgx5LpBe0Da81xCioHw3zY89jeyuRzPiqYdGaBFgZaga1k6O+abtGQ9z749Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePq10ryA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePq10ryA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81525C433C7;
	Mon,  1 Apr 2024 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988414;
	bh=GpgERM70bnoUnMFiKshvQE6CDWxKYg3WtMPTOG0Y1vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePq10ryASGTgA0i0e0CxDe/NBCoF51x+wikrz8zqQMBH3PVYw98H6qQpB7h12w5ch
	 ttvu4v7HEiEujCV0Sgl7/GOxyy9Wp7Q1oeDyRGVGRI+GX/7dwXsGjMQlvKg2Al3mQF
	 NISRNiWYivzTtiJtkpFhrD89ZZnt1xnUUBoQE+t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 178/432] cifs: delete unnecessary NULL checks in cifs_chan_update_iface()
Date: Mon,  1 Apr 2024 17:42:45 +0200
Message-ID: <20240401152558.455843979@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c3a11c0ec66c1e0652e3a2bb4f5cc74eea0ba486 ]

We return early if "iface" is NULL so there is no need to check here.
Delete those checks.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 16a57d768111 ("cifs: reduce warning log level for server not advertising interfaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 94c5d50aa3474..0c2ac8d929a26 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -472,27 +472,23 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 		kref_put(&old_iface->refcount, release_iface);
 	} else if (!chan_index) {
 		/* special case: update interface for primary channel */
-		if (iface) {
-			cifs_dbg(FYI, "referencing primary channel iface: %pIS\n",
-				 &iface->sockaddr);
-			iface->num_channels++;
-			iface->weight_fulfilled++;
-		}
+		cifs_dbg(FYI, "referencing primary channel iface: %pIS\n",
+			 &iface->sockaddr);
+		iface->num_channels++;
+		iface->weight_fulfilled++;
 	}
 	spin_unlock(&ses->iface_lock);
 
-	if (iface) {
-		spin_lock(&ses->chan_lock);
-		chan_index = cifs_ses_get_chan_index(ses, server);
-		if (chan_index == CIFS_INVAL_CHAN_INDEX) {
-			spin_unlock(&ses->chan_lock);
-			return 0;
-		}
-
-		ses->chans[chan_index].iface = iface;
+	spin_lock(&ses->chan_lock);
+	chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
 		spin_unlock(&ses->chan_lock);
+		return 0;
 	}
 
+	ses->chans[chan_index].iface = iface;
+	spin_unlock(&ses->chan_lock);
+
 	return rc;
 }
 
-- 
2.43.0



