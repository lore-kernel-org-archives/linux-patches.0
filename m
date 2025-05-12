Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB772293B6B;
	Mon, 12 May 2025 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073256; cv=none; b=JelFYO3pkIfOd8j6NlNsKRTQ5N5N4UT+fEzswCAbs+Ay5IGBCdneABjsUlLofFi7Lv6e0I9qomMXiwybcwquJCRzURQB+Rsg9+z+KuMRr7LmDDiQs8HjmqZkYFyOQ/de6gk9g9UJer0Oh94KRD9vZJp4pY3G3Ysf0QP44EB8KDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073256; c=relaxed/simple;
	bh=yGFfzQp17MJ2Lyz2FDspueSiBgvhNasMGMI6yj69WvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3DavfnR60f6KyRhIssTE+lxGSxgyhVsra6vwfStBa/PojEiU3uaTMPAlYOwUkiUkjK5UyK5OZBtQ5jOaNBgJdNyHECOHlXxuW25a1N60EXKMDHn4gi+JDF5u3iRILoJMQTpRLj3JKkQp92WJObQ87xgmNbqGF3LQFNFZdp//EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZPuu6Zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZPuu6Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E378C4CEE9;
	Mon, 12 May 2025 18:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073256;
	bh=yGFfzQp17MJ2Lyz2FDspueSiBgvhNasMGMI6yj69WvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZPuu6Zv84Nk/DMZUdLSGH6YMxXN7XIiy45QkWrcug8usDIrA298FxC3HGcUyCNEN
	 ByDDWQGyN5Z+/SEDs8NLjHoZtNChs6KA+574DSwFGolqoraJcbWUjdCFfZUGUxrRG8
	 tWKNvCR9wrhjnkFyNKCi3LAl3pgBvOfkngkOyRi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 006/113] ksmbd: prevent rename with empty string
Date: Mon, 12 May 2025 19:44:55 +0200
Message-ID: <20250512172027.959400492@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 53e3e5babc0963a92d856a5ec0ce92c59f54bc12 upstream.

Client can send empty newname string to ksmbd server.
It will cause a kernel oops from d_alloc.
This patch return the error when attempting to rename
a file or directory with an empty new name string.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -632,6 +632,11 @@ smb2_get_name(const char *src, const int
 		return name;
 	}
 
+	if (*name == '\0') {
+		kfree(name);
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (*name == '\\') {
 		pr_err("not allow directory name included leading slash\n");
 		kfree(name);


