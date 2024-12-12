Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80149223E83;
	Thu, 12 Dec 2024 16:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020949; cv=none; b=dadvE/nUuYDjMziuiDeB02o+LCBJ6HlWJluxpNIS4dHGwnKp3EsGtuCkYYTkO8tWlHST6XRsuPDVOB6UaIv7CqNveeV8lVTJIPMXFAL1jOsLUgOw7IIP+elFsh6LEjtmAX1h/EqNPULzbbYIyCohP42e/XN8mi14gpSOWXm0n4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020949; c=relaxed/simple;
	bh=aOsMndAkLM5Lye1kaCEAwOMIUSpYgarkECsGkqRLZFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfENipmNei0zs2XfNxP9qpLFNwwsDnK5rvYymc9iXx6r2oNmMuHQd/A64oq4XPv8n4LfBnbWGdvjxOevZ5tKnwqVm6e3/I6kvUdXLdP8BQam394LcqjNeoyorinb83S/FL1xphhn0r8d0BY3mx1mpVrDzmteTUVaetDe1kOWUgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9iylI8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9iylI8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C941BC4CED0;
	Thu, 12 Dec 2024 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020949;
	bh=aOsMndAkLM5Lye1kaCEAwOMIUSpYgarkECsGkqRLZFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9iylI8ANbqtcNrBWDOQawG4YMK09a4osji0fgTVfGn50JxQGhQoC0IO/iNJ4Ji5I
	 0gXxBLtNOt/Rt+SnIlwPB/wZgLzIN+opgjyJNTDkbP1G+sWpK78DPQJAeSAfSZPnzh
	 ep93i8P2oL8gk/C05PHjFxXI4ccJ/cc1D3Q4OyYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordy Zomer <jordyzomer@google.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 605/772] ksmbd: fix Out-of-Bounds Read in ksmbd_vfs_stream_read
Date: Thu, 12 Dec 2024 15:59:10 +0100
Message-ID: <20241212144414.923101060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordy Zomer <jordyzomer@google.com>

commit fc342cf86e2dc4d2edb0fc2ff5e28b6c7845adb9 upstream.

An offset from client could be a negative value, It could lead
to an out-of-bounds read from the stream_buf.
Note that this issue is coming when setting
'vfs objects = streams_xattr parameter' in ksmbd.conf.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6370,6 +6370,10 @@ int smb2_read(struct ksmbd_work *work)
 	}
 
 	offset = le64_to_cpu(req->Offset);
+	if (offset < 0) {
+		err = -EINVAL;
+		goto out;
+	}
 	length = le32_to_cpu(req->Length);
 	mincount = le32_to_cpu(req->MinimumCount);
 


