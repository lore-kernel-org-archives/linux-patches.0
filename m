Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7821F03DE;
	Thu, 25 Jun 2026 13:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393098; cv=none; b=TQsjWjpG064f4BJt7MAetRO8NvwT/WYy8D9xEy8FXVuvuagGehWUWiqlEMn72UKTVwbM0Orhsw9EiqlbRTwXNo6ezXa3f+KtRVgMGUfYBChaRt/Xe+EtE75q6YZ5wM/Vm+5gPqyT3yvPaGZgqN5DcDL7rpCtgwiuQiWl/FWdeBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393098; c=relaxed/simple;
	bh=Jw1mKkzjPPo+zA5y/BEzCZqmn/bFu0aLufrxT2Xh5K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REXUU5JL9qKI0tKH+Nv8sV78c7S2wL9QxXkf5y8Lb9D/qHD5Ji2QAFAMhzB+BHy6YawKhCe4LGysBdoXwdK6cdSPZFD/KGVYEqjYCHNzuT6G20L3USfdjX0wfbrmNqW2lrL6Z2ei07A3T3Dt1Ef5vy5OE0FUN7WfMH/hZUMaFGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHsIhUMS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHsIhUMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38751F000E9;
	Thu, 25 Jun 2026 13:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393097;
	bh=+gsUtoPyAQ0cwonMqc6oykYvGpDegwEVMn4Oz11MHdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHsIhUMSTVnDE9oe+PDNllXUsr51SAGt1CYHjJ1+VaK0iPChl1p60ZLhRmA7dEzYB
	 o8F/kkB8VizraSHrONNohYevQmMDd9YzLUB+iZMPgH29P6J99wTCzQMMQE+DB4PW6b
	 fOoeLfyEMg89bt70uFgAGiQQEuzhn1ikD/RQXAy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 7.0 43/49] vc_screen: fix null-ptr-deref in vcs_notifier() during concurrent vcs_write
Date: Thu, 25 Jun 2026 14:03:55 +0100
Message-ID: <20260625125643.598251409@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

commit a287620312dc6dcb9a093417a0e589bf30fcf38a upstream.

A KASAN null-ptr-deref was observed in vcs_notifier():

BUG: KASAN: null-ptr-deref in vcs_notifier+0x98/0x130
Read of size 2 at addr qmp_cmd_name: qmp_capabilities, arguments: {}

The issue is a race condition in vcs_write(). When the console_lock is
temporarily dropped (to copy data from userspace), the vc_data pointer
obtained from vcs_vc() may become stale. After re-acquiring the lock,
vcs_vc() is called again to re-validate the pointer. If the vc has been
deallocated in the meantime, vcs_vc() returns NULL, and the while loop
breaks (with written > 0). However, after the loop, vcs_scr_updated(vc)
is still called with the now-NULL vc pointer, leading to a null pointer
dereference in the notifier chain (vcs_notifier dereferences param->vc).

Fix this by adding a NULL check for vc before calling vcs_scr_updated().

Fixes: 8fb9ea65c9d1 ("vc_screen: reload load of struct vc_data pointer in vcs_write() to avoid UAF")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260604060734.2914976-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vc_screen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -686,7 +686,7 @@ vcs_write(struct file *file, const char
 	}
 	*ppos += written;
 	ret = written;
-	if (written)
+	if (written && vc)
 		vcs_scr_updated(vc);
 
 	return ret;


