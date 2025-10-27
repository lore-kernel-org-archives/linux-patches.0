Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8371A31B819;
	Mon, 27 Oct 2025 18:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591265; cv=none; b=YOd8MdotmZtepJ2a75YMJvKSh0ibnEBepk5DkpdkQVr9ncyZ4wjvooKty3sSEf+Ztn/TEL9NC2FBwMRzEHpIjEhISL/7TYnUHZgTP4k2ay1YIuvI/6PQovWlE5vpzXhor82et7x0b17eftpegm5zFbGJKS5lTwr3//ONFN44AKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591265; c=relaxed/simple;
	bh=ojjqH+Z4MnfhhwwJIerQWMDDII4E+kQVmYjn01ghSBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJkv5duAp+ZsE8DIWtsBuuupj57iREA9UWxbqaislNkwN1GCRAmcSiKK1MyEqINrg3Qv/GZfnp/H69ExI43UwgFRKnju2UVQGg9VwSjsKUs0VTUY3maFj6vATyxywTRXvm0LeP5McAJ3EEwWfxp9uLR4oM002iqL6FZeynmzfmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPGJVHgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPGJVHgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EC7C4CEF1;
	Mon, 27 Oct 2025 18:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591265;
	bh=ojjqH+Z4MnfhhwwJIerQWMDDII4E+kQVmYjn01ghSBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPGJVHgQttdgXWsLug+Ue36A/iwOXm+gvmYGrIXUmY6zU5e3ixh4VIyni9djLGjAB
	 wsPq2mwK/DWEtxq/2EbimIKajlmumKtWPBc9c91yuAgicLqR5YD10IeTutrxzH91fM
	 f5ZtS3LG7uDK1rSr9j6Y3vtCBFTLIUW5v9bK+hBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 131/332] xen/events: Cleanup find_virq() return codes
Date: Mon, 27 Oct 2025 19:33:04 +0100
Message-ID: <20251027183528.090100400@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

commit 08df2d7dd4ab2db8a172d824cda7872d5eca460a upstream.

rc is overwritten by the evtchn_status hypercall in each iteration, so
the return value will be whatever the last iteration is.  This could
incorrectly return success even if the event channel was not found.
Change to an explicit -ENOENT for an un-found virq and return 0 on a
successful match.

Fixes: 62cc5fc7b2e0 ("xen/pv-on-hvm kexec: rebind virqs to existing eventchannel ports")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250828003604.8949-2-jason.andryuk@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1263,10 +1263,11 @@ static int find_virq(unsigned int virq,
 {
 	struct evtchn_status status;
 	evtchn_port_t port;
-	int rc = -ENOENT;
 
 	memset(&status, 0, sizeof(status));
 	for (port = 0; port < xen_evtchn_max_channels(); port++) {
+		int rc;
+
 		status.dom = DOMID_SELF;
 		status.port = port;
 		rc = HYPERVISOR_event_channel_op(EVTCHNOP_status, &status);
@@ -1276,10 +1277,10 @@ static int find_virq(unsigned int virq,
 			continue;
 		if (status.u.virq == virq && status.vcpu == xen_vcpu_nr(cpu)) {
 			*evtchn = port;
-			break;
+			return 0;
 		}
 	}
-	return rc;
+	return -ENOENT;
 }
 
 /**


