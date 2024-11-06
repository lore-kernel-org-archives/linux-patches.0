Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878B21F428D;
	Wed,  6 Nov 2024 12:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897524; cv=none; b=Jo9/gnZwo96qYo0TKejiNfKa6K2+eeVosdV70pHFbsM5No7txP90b9FlkQVpoK4SdoBdWvgynf7r0yj3231nZ3f9CvAmTbuMbRMBo1z0gXInEPn2DVuFjj+VqwuNxoDnOiTIcQvdUmM5QL7UmTge4cfkWuCWMCzEvDC1m7pJFq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897524; c=relaxed/simple;
	bh=Q+n3u6ZEKXxyhc7B9UUO+mQj0+NiMYJ+LEaEppTomFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3SedZeEYA5sA373gFdfqL+HynjmrI/pfNoMA8rrpZSaJXRqX4ouL8DimO1GKfr5+FY9kVhQYxhy5Ntil1wocj2wwvWX4QgQnXsaKKKmRNweLQejdiKOJSY0vekdLSOGVJcZvXtSzquk+EEvp6sbH2nV+DILTjjmCWjPe5Gv+lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AoMz9Ol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AoMz9Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E737C4CECD;
	Wed,  6 Nov 2024 12:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897524;
	bh=Q+n3u6ZEKXxyhc7B9UUO+mQj0+NiMYJ+LEaEppTomFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AoMz9Ol3Gv4QN/bROnCINCKoFSZkDSuc4MYpxFjgSfbsPhqfwKO+6N+erVe/IwB9
	 RuHatRMazpGpUiKUUQFAeBMH+JqHX3fv765ZyOhKIjUDjHYz3DnHs8QtdVtAg0HvB+
	 W9ZuILUk1h5hcsgOedDIn7YlBA+V59Y72/bvp1EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>
Subject: [PATCH 6.6 083/151] usb: typec: fix unreleased fwnode_handle in typec_port_register_altmodes()
Date: Wed,  6 Nov 2024 13:04:31 +0100
Message-ID: <20241106120311.145172321@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 9581acb91eaf5bbe70086bbb6fca808220d358ba upstream.

The 'altmodes_node' fwnode_handle is never released after it is no
longer required, which leaks the resource.

Add the required call to fwnode_handle_put() when 'altmodes_node' is no
longer required.

Cc: stable@vger.kernel.org
Fixes: 7b458a4c5d73 ("usb: typec: Add typec_port_register_altmodes()")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241021-typec-class-fwnode_handle_put-v2-1-3281225d3d27@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -2194,6 +2194,7 @@ void typec_port_register_altmodes(struct
 		altmodes[index] = alt;
 		index++;
 	}
+	fwnode_handle_put(altmodes_node);
 }
 EXPORT_SYMBOL_GPL(typec_port_register_altmodes);
 


