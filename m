Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F45435C694;
	Tue, 21 Jul 2026 22:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672680; cv=none; b=MytZzm4CpDcTDhbtHHRXyU9vhaLWAKOr41mNrltk+/IYM4R7H56fEogJqTDHtQToifZZfzJEUQbondwtoJ/E/tONmHE91cXgwWnNn2Rt45SbMUmg96savu3MLpX/ULXMRVsfIP0BVGNgVNwxPw6Vt+Eieyi2uMMXqFVNu8qBZ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672680; c=relaxed/simple;
	bh=Ob5rX0VkKwZuQ2/bAUrLCAQHOdh1bjY9pbF9iefmwqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7aS8SpoJbDHnD8HvzVh6jrUiTmPTVi5GGDVf3pkWbzl9GWer+KaksqsuhxH+F8iIVFG/iVV2vQHzy/bhVrjPqkZtEwA8RQaqryuaF23+alp/HKfTf7kx/MmtazrYHHgtfbCqECe+KDYP0gjHuISsA+ERVsu2Sl489kR6BY6Yn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgG/RBY7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgG/RBY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CE11F000E9;
	Tue, 21 Jul 2026 22:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672679;
	bh=XUwbx7+EAmGOPrlmCYbUZRZb0kJiEIuSsD6yWoxND/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgG/RBY7PEs7c2lXTsBsZtR9NDhErfZ39YgUOndzXdjcCG7l36zG3C/zcdis2Zx4k
	 aFBXNIAgHexFJzm/nxYbrAdHQeFba14fEmWjjxTh+y2DGnIaqDJpQUQCy/tJNmcfya
	 1IDeEP+i7MPGpGloDBEYZzToKvpAgB1YqwPjhOdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 715/843] llc: fix SAP refcount leak when creating incoming sockets
Date: Tue, 21 Jul 2026 17:25:50 +0200
Message-ID: <20260721152422.131920727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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


