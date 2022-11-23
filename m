Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCBE1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6BFC433D7;
	Wed, 23 Nov 2022 09:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197539;
	bh=H7At9qYQ3/buVlEQdSTK/awlDtqr/RbiPK3w/SiG3/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtHiM0L6k28xQMxKYsVrqgbqF49v6rpxpFJzr++z2EVq3e8fO1m2gnfKHeCg9dL+f
	 6xvAGYilndTYMGgbVPl2UaSnWX+Kp1kl6ZTx6k5Xk63HNL8H86NjGnnbUdjIfdg3Tk
	 R821FYYiBa62eA5J51lGUFDNf8gR1sF/XNQGvCiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6f0c896c5a9449a10ded@syzkaller.appspotmail.com,
	Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 301/314] KVM: x86/xen: Fix eventfd error handling in kvm_xen_eventfd_assign()
Date: Wed, 23 Nov 2022 09:52:26 +0100
Message-Id: <20221123084639.193736190@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>

commit 7353633814f6e5b4899fb9ee1483709d6bb0e1cd upstream.

Should not call eventfd_ctx_put() in case of error.

Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
Reported-by: syzbot+6f0c896c5a9449a10ded@syzkaller.appspotmail.com
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Message-Id: <20221028092631.117438-1-eiichi.tsukata@nutanix.com>
[Introduce new goto target instead. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1667,18 +1667,18 @@ static int kvm_xen_eventfd_assign(struct
 	case EVTCHNSTAT_ipi:
 		/* IPI  must map back to the same port# */
 		if (data->u.evtchn.deliver.port.port != data->u.evtchn.send_port)
-			goto out; /* -EINVAL */
+			goto out_noeventfd; /* -EINVAL */
 		break;
 
 	case EVTCHNSTAT_interdomain:
 		if (data->u.evtchn.deliver.port.port) {
 			if (data->u.evtchn.deliver.port.port >= max_evtchn_port(kvm))
-				goto out; /* -EINVAL */
+				goto out_noeventfd; /* -EINVAL */
 		} else {
 			eventfd = eventfd_ctx_fdget(data->u.evtchn.deliver.eventfd.fd);
 			if (IS_ERR(eventfd)) {
 				ret = PTR_ERR(eventfd);
-				goto out;
+				goto out_noeventfd;
 			}
 		}
 		break;
@@ -1718,6 +1718,7 @@ static int kvm_xen_eventfd_assign(struct
 out:
 	if (eventfd)
 		eventfd_ctx_put(eventfd);
+out_noeventfd:
 	kfree(evtchnfd);
 	return ret;
 }


