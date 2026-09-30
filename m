Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E37511225;
	Wed, 30 Sep 2026 18:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792300; cv=none; b=iyoI5QiK84ZiILC8mn6GgVUqBQ0hXU2WY2ilsNFRpeZDBNYN72toFPOCmTitI+LgWTCHp1ND4wYsUg/0IIB9dWvdSXuloLgxholwfA/XgJR7607aDt5nRVFMHq0jklqWAh/0t9BDhRvRtRxpejdwWvGFSGbfQIGFBFsMlHH3Xco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792300; c=relaxed/simple;
	bh=IVIpfcIlE6xTlz/lhurth0otbxpM80Y2PevGPdzBIpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CoqvkO+hH6rLZ1Xw6ptlZ/X1oODiLM5AmUbg6qhIECNhdgKz95uzPDLjs3a6lTY0Se4sQ7JnX6Y2xpmcMvfX/bPGN06QVrEIA5lbEBPUhbsO+R8ilNwTFkG3a9cij8XPSQjP1C2WzZQlS2LlQ5ozFROU/COsqMlCAMmDFcd37FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OubVb9jr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OubVb9jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CEB1F000FF;
	Wed, 30 Sep 2026 18:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792299;
	bh=gxKrsSHPUUFjG7k24FUP1yn5ACIY2cN7+ovRQIzJOnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OubVb9jrcPmNZLuA5ZfqPXXDP0svSuhhSN/OoAYDLn9YtgWcNugvqMChkxjbRhbCm
	 wLBrukYzaBCJ0KMM2LHw0OMqlnwRgKbN35DMgqOW28gXb9Z0HEQ2iJbZRVFlwAh+nx
	 vy2VrvhxMsJOWwBcAooLS2cmKjlAlUXOhnYIARAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 561/752] Input: zero ff_effect before compat copy in input_ff_effect_from_user
Date: Wed, 30 Sep 2026 17:27:11 +0200
Message-ID: <20260930152410.378870642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

commit f84819ef8d66931ee3998fee3c4f03230f4cb6cc upstream.

In the compat path input_ff_effect_from_user() aliases the caller's
native struct ff_effect with the smaller struct ff_effect_compat and
copies only the compat sized prefix:

	compat_effect = (struct ff_effect_compat *)effect;

	if (copy_from_user(compat_effect, buffer,
			   sizeof(struct ff_effect_compat)))

The tail of the native structure is never written. Callers pass an
uninitialized on-stack object, for example evdev_do_ioctl() for
EVIOCSFF, so those bytes keep their previous stack contents.
input_ff_upload() then stores the full native structure in
ff->effects[id], from where a uinput based force feedback daemon can
read it back via UI_BEGIN_FF_UPLOAD, disclosing kernel stack memory to
userspace.

Zero the effect before the compat copy.

Fixes: 2d56f3a32c0e ("Input: refactor evdev 32bit compat to be shareable with uinput")
Cc: stable@vger.kernel.org
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Link: https://patch.msgid.link/20260901130629.24078-3-ivanrwcm25@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/input-compat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/input-compat.c
+++ b/drivers/input/input-compat.c
@@ -75,6 +75,8 @@ int input_ff_effect_from_user(const char
 		 */
 		compat_effect = (struct ff_effect_compat *)effect;
 
+		memset(effect, 0, sizeof(*effect));
+
 		if (copy_from_user(compat_effect, buffer,
 				   sizeof(struct ff_effect_compat)))
 			return -EFAULT;


