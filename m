Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4BF1D86E8;
	Wed,  6 Nov 2024 12:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897109; cv=none; b=Sm6FiLy09QMWr9nv/XBk8iPqbQgg4l66cj/4LGeZi4EQV03ia/fGYnzPwJ3qmn94LyOv4JWejxBojSSmpgB0fm+A40hlV6w8I95bIxGmq9CU0SgOdHGjbbkFCAl//DbbsZE/2lQjN0SQ1zdB8kJMC8MwW8HZzvoC5KPY8nl5jK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897109; c=relaxed/simple;
	bh=qk24mQWAv4SnIlkEKnB/5nbUb5E84eRLGnYlw1MH+uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWQFi4f0vf2cSlTo1uF1+lsfBYJufL08ZGtVM8tbtWc9wCqwucGDQcFHZ9PCZREkPSDbcrsvM5gXvPe1kioRZr9MpH7RuhNQj1jmrH/3LTe+p7a/7+ym5FcB9LT4M2VH6h7jYh821xlT34oO1BYAtgKOMN3pTNZfex8+dtSv5KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XO01i8Kx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XO01i8Kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FC7C4CECD;
	Wed,  6 Nov 2024 12:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897109;
	bh=qk24mQWAv4SnIlkEKnB/5nbUb5E84eRLGnYlw1MH+uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO01i8KxH8RVjuBAixNABH7pJdNLH2XD7SFYoH5zA4Ejhu9G4VpwznCTW3F/hUVVp
	 aksUkc5XQmU15l77BpHfM51LZLaQH4MeJO1xESa4DeSv1QQyNsglcTqC/Mq5+e2P2G
	 PO+BplpBeUo2cdHSk1luDS00D/E6/oKzJF368Rzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>
Subject: [PATCH 6.1 068/126] usb: typec: fix unreleased fwnode_handle in typec_port_register_altmodes()
Date: Wed,  6 Nov 2024 13:04:29 +0100
Message-ID: <20241106120307.928768029@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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
@@ -2165,6 +2165,7 @@ void typec_port_register_altmodes(struct
 		altmodes[index] = alt;
 		index++;
 	}
+	fwnode_handle_put(altmodes_node);
 }
 EXPORT_SYMBOL_GPL(typec_port_register_altmodes);
 


