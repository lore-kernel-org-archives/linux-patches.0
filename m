Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEF03B71A0;
	Tue, 21 Jul 2026 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670416; cv=none; b=KqsVSDLVh5NHqsjuvPwAJy3E9crAVk9a2HfH7rGeHpTHOL18liIOfxlAnRn1yugKuQ9iER35EMlHAnuxYugZpJPw86VclQAbYChPCJlA7Yza5dZYE4Hd0PGtkR8lbVBbhUkcYUAMhz6ptrr3bk4KJximwN6XM6ssyTlgYJz47js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670416; c=relaxed/simple;
	bh=QYhwlorpM01stDeZmHq4BwDKsGDMvBgZlPekZZZ+5OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCtVokSNgCebR4fWCOu3E8phfdQqKgCOxEFPvVHulhwWIwVqukbaX3CSPpFtuYALT4EOHtOdtjQMiXuQXS5P3ZxejQb2WN3aZn/Y9gmw4PaGkXaN/6GyIBySFGNxdWYvPEeq3HJ38RI4epFKtpv9P/LQf564d9sESjugGLSUeuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAVBAY/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAVBAY/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43541F000E9;
	Tue, 21 Jul 2026 21:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670415;
	bh=CMFp45AJ0yEkJMDM5NpumkYv36IL7vwWaXprW3yYmsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAVBAY/Ohffz1N8ZRaUE8fLQeHXnmoxLqxjVX+w5s1p2NUxonxLCzU+59Sls5gh/r
	 UH6LQnFp8MvJWhF/EnC2xkG9CnCXZvQTGENUKYpKE/pKr8iA/5evWNbC/OFMcoc0f0
	 uPBKPDyDsk0rFwcUPhweNfiuA8ueRmG638V7aP1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0923/1067] llc: fix SAP refcount leak when creating incoming sockets
Date: Tue, 21 Jul 2026 17:25:24 +0200
Message-ID: <20260721152445.182290103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 2c72eb6286347d05a885412fb076993bd5286b53 upstream.

llc_sap_add_socket() takes a SAP reference for each socket added to a SAP,
and llc_sap_remove_socket() releases it. llc_create_incoming_sock() takes
an additional SAP reference after adding the child socket.

This extra reference was balanced by an explicit llc_sap_put() in
llc_ui_release() until commit 3100aa9d74db ("llc: fix SAP reference
counting w.r.t. socket handling") removed that put. The corresponding hold
in the accept path was left behind.

When such a child socket is removed, only the reference taken by
llc_sap_add_socket() is released. The extra reference keeps the SAP alive
after its last socket is removed. Remove the obsolete hold.

Fixes: 3100aa9d74db ("llc: fix SAP reference counting w.r.t. socket handling")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260712130343.518797-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/llc_conn.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -761,7 +761,6 @@ static struct sock *llc_create_incoming_
 	newllc->dev = dev;
 	dev_hold(dev);
 	llc_sap_add_socket(llc->sap, newsk);
-	llc_sap_hold(llc->sap);
 out:
 	return newsk;
 }


