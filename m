Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D0913C831
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 07:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712732422; cv=none; b=VrIXd6F9LEYKwR66kUfmhwZ4CI5nwaZfguKe7bb09VT7gfbfoxt6YclHaQSWrfnvY3Uiog27SwunVKA0i6TjFhEoIChmmS8QeCN1nuVBbZoes1p+cUC3aLJ4a3DmS/RzpOBFst5AcEj2sVj+YYKIMuAjQsRlcOv0N3mSvT94tac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712732422; c=relaxed/simple;
	bh=G1cU7ek2iNnWWUDgwznivKTnG1/ppEH0ZuFtdK/lb5o=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=mnbZpLAcgMyoZLPvN6dwTfL5Zh0VIzc6zGllYxkk2i2GgG8LKfQgR27ewpvsxhBuF9Dv/hWSOHdbP27rgztK84/yrjiZqMn1t4RxwJuq8QtsvmBT3PYL18Z2pP8rDrVl2zx2UPaUXc2mYZ6vSp5GQKPBEmbErxiYuc/mX4/2AXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=XLSrETaa; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="XLSrETaa"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1712732410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+I18PrA01CP1wCwzNYf/A57nhmF0Jn4a+y2o+TjihTQ=;
	b=XLSrETaah8/ax7cc2PhsFv0hMxiv1P4HTW/Y6mysmsSsCMUfN92EVtDFIxgt9zYzrljL/1
	5gLn5H7igs3KSsAQ==
Content-Type: multipart/mixed; boundary="------------jAmz1BtPPXML2ujfVW3AXWi5"
Message-ID: <25704cce-2d6e-4904-a42d-47c96056459d@hardfalcon.net>
Date: Wed, 10 Apr 2024 09:00:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
To: Borislav Petkov <bp@alien8.de>, Ard Biesheuvel <ardb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125317.917032769@linuxfoundation.org>
 <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net>
 <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>
Content-Language: en-US
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>

This is a multi-part message in MIME format.
--------------jAmz1BtPPXML2ujfVW3AXWi5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-04-10 07:34] Borislav Petkov:
> On Tue, Apr 09, 2024 at 06:38:53PM +0200, Pascal Ernster wrote:
>> Just to make sure this doesn't get lost: This patch causes the kernel to not
>> boot on several x86_64 VMs of mine (I haven't tested it on a bare metal
>> machine). For details and a kernel config to reproduce the issue, see https://lore.kernel.org/stable/fd186a2b-0c62-4942-bed3-a27d72930310@hardfalcon.net/
> 
> I see your .config there. How are you booting the VMs? qemu cmdline?

I've seen the issue on both a Hetzner VM (UEFI mode, classical video 
screen, no access to a serial terminal) and on libvirt VMs (passthrough 
of the host systems Kaby Lake CPU, libvirt devices whereever possible, 
no GPU, serial console, kernel, initrd and boot cmdline configured 
directly in libvirt, without using a bootloader). I can't easily switch 
between BIOS and UEFI on my Hetzner VM, but at least on my libvirt VMs, 
the issue occurs regardless of whether I configure the libvirt VMs to 
start in UEFI or in BIOS mode.

I haven't tried manually calling qemu, and I haven't tried the broken 
kernel on bare metal, but I suspect that the issue occur there as well 
if I tested it.

One important aspect I should have mentioned: The config that I've 
posted is a localmodconfig from a libvirt VM that I used for bisecting 
this, so it is possible that a kernel built with that exact it might not 
be able to boot on a Hetzner VM, and it probably wouldn't be able to 
boot on a bare metal machine. It is sufficient to reproduce the issue on 
a libvirt VM, though.

I've attached a simplified but sufficient version of my original libvirt 
VM definition that you can use to reproduce the issue. With this VM 
defintion, the "working" kernel (from the 0.2 PKGBUILD that reverts your 
patch) will complain about a missing rootfs, but besides from not 
finding a rootfs, it will boot, show messages and eventually settle on a 
low CPU load. With the broken kernel (from the 0.1 PKGBUILD that 
includes your patch), it won't output even a single message, and it will 
remain at 100% CPU from the moment you boot the VM to the moment you 
kill the VM.


Regards
Pascal
--------------jAmz1BtPPXML2ujfVW3AXWi5
Content-Type: text/xml; charset=UTF-8; name="libvirt-vm.xml"
Content-Disposition: attachment; filename="libvirt-vm.xml"
Content-Transfer-Encoding: base64

PGRvbWFpbiB0eXBlPSJrdm0iPgogIDxuYW1lPmtlcm5lbF9pc3N1ZTwvbmFtZT4KICA8dXVp
ZD4zZWY5NDU4NS05ZWQyLTQ2NGMtOTdjYS01NDZmZTliNDJlMmQ8L3V1aWQ+CiAgPG1lbW9y
eSB1bml0PSJLaUIiPjIwOTcxNTI8L21lbW9yeT4KICA8Y3VycmVudE1lbW9yeSB1bml0PSJL
aUIiPjIwOTcxNTI8L2N1cnJlbnRNZW1vcnk+CiAgPHZjcHUgcGxhY2VtZW50PSJzdGF0aWMi
PjE8L3ZjcHU+CiAgPHJlc291cmNlPgogICAgPHBhcnRpdGlvbj4vbWFjaGluZTwvcGFydGl0
aW9uPgogIDwvcmVzb3VyY2U+CiAgPG9zPgogICAgPHR5cGUgYXJjaD0ieDg2XzY0IiBtYWNo
aW5lPSJwYy1xMzUtOC4yIj5odm08L3R5cGU+CiAgICA8a2VybmVsPi92YXIvbGliL2xpYnZp
cnQvYm9vdC92bWxpbnV6LWxpbnV4LWhhcmRlbmVkPC9rZXJuZWw+CiAgICA8aW5pdHJkPi92
YXIvbGliL2xpYnZpcnQvYm9vdC9pbml0cmFtZnMtbGludXgtaGFyZGVuZWQuaW1nPC9pbml0
cmQ+CiAgICA8Y21kbGluZT5jb25zb2xlPXR0eVMwLDExNTIwMCBpbnRlbF9pb21tdT1vbiBs
b2NrZG93bj1jb25maWRlbnRpYWxpdHkgaWEzMl9lbXVsYXRpb249MCB1c2Jjb3JlLm5vdXNi
IGxvZ2xldmVsPTcgZWFybHlwcmludGs9c2VyaWFsLHR0eVMwLDExNTIwMDwvY21kbGluZT4K
ICAgIDxib290IGRldj0iaGQiLz4KICA8L29zPgogIDxmZWF0dXJlcz4KICAgIDxhY3BpLz4K
ICAgIDxhcGljLz4KICAgIDxzbW0gc3RhdGU9Im9uIi8+CiAgPC9mZWF0dXJlcz4KICA8Y3B1
IG1vZGU9Imhvc3QtcGFzc3Rocm91Z2giIGNoZWNrPSJub25lIiBtaWdyYXRhYmxlPSJvbiIv
PgogIDxjbG9jayBvZmZzZXQ9InV0YyI+CiAgICA8dGltZXIgbmFtZT0icnRjIiB0aWNrcG9s
aWN5PSJjYXRjaHVwIi8+CiAgICA8dGltZXIgbmFtZT0icGl0IiB0aWNrcG9saWN5PSJkZWxh
eSIvPgogICAgPHRpbWVyIG5hbWU9ImhwZXQiIHByZXNlbnQ9Im5vIi8+CiAgPC9jbG9jaz4K
ICA8b25fcG93ZXJvZmY+ZGVzdHJveTwvb25fcG93ZXJvZmY+CiAgPG9uX3JlYm9vdD5yZXN0
YXJ0PC9vbl9yZWJvb3Q+CiAgPG9uX2NyYXNoPmRlc3Ryb3k8L29uX2NyYXNoPgogIDxwbT4K
ICAgIDxzdXNwZW5kLXRvLW1lbSBlbmFibGVkPSJubyIvPgogICAgPHN1c3BlbmQtdG8tZGlz
ayBlbmFibGVkPSJubyIvPgogIDwvcG0+CiAgPGRldmljZXM+CiAgICA8ZW11bGF0b3I+L3Vz
ci9iaW4vcWVtdS1zeXN0ZW0teDg2XzY0PC9lbXVsYXRvcj4KICAgIDxjb250cm9sbGVyIHR5
cGU9InVzYiIgaW5kZXg9IjAiIG1vZGVsPSJub25lIi8+CiAgICA8Y29udHJvbGxlciB0eXBl
PSJwY2kiIGluZGV4PSIwIiBtb2RlbD0icGNpZS1yb290Ii8+CiAgICA8Y29udHJvbGxlciB0
eXBlPSJwY2kiIGluZGV4PSIxIiBtb2RlbD0icGNpZS1yb290LXBvcnQiPgogICAgICA8bW9k
ZWwgbmFtZT0icGNpZS1yb290LXBvcnQiLz4KICAgICAgPHRhcmdldCBjaGFzc2lzPSIxIiBw
b3J0PSIweDgiLz4KICAgICAgPGFkZHJlc3MgdHlwZT0icGNpIiBkb21haW49IjB4MDAwMCIg
YnVzPSIweDAwIiBzbG90PSIweDAxIiBmdW5jdGlvbj0iMHgwIiBtdWx0aWZ1bmN0aW9uPSJv
biIvPgogICAgPC9jb250cm9sbGVyPgogICAgPGNvbnRyb2xsZXIgdHlwZT0icGNpIiBpbmRl
eD0iMiIgbW9kZWw9InBjaWUtcm9vdC1wb3J0Ij4KICAgICAgPG1vZGVsIG5hbWU9InBjaWUt
cm9vdC1wb3J0Ii8+CiAgICAgIDx0YXJnZXQgY2hhc3Npcz0iMiIgcG9ydD0iMHg5Ii8+CiAg
ICAgIDxhZGRyZXNzIHR5cGU9InBjaSIgZG9tYWluPSIweDAwMDAiIGJ1cz0iMHgwMCIgc2xv
dD0iMHgwMSIgZnVuY3Rpb249IjB4MSIvPgogICAgPC9jb250cm9sbGVyPgogICAgPGNvbnRy
b2xsZXIgdHlwZT0icGNpIiBpbmRleD0iMyIgbW9kZWw9InBjaWUtcm9vdC1wb3J0Ij4KICAg
ICAgPG1vZGVsIG5hbWU9InBjaWUtcm9vdC1wb3J0Ii8+CiAgICAgIDx0YXJnZXQgY2hhc3Np
cz0iMyIgcG9ydD0iMHhhIi8+CiAgICAgIDxhZGRyZXNzIHR5cGU9InBjaSIgZG9tYWluPSIw
eDAwMDAiIGJ1cz0iMHgwMCIgc2xvdD0iMHgwMSIgZnVuY3Rpb249IjB4MiIvPgogICAgPC9j
b250cm9sbGVyPgogICAgPGNvbnRyb2xsZXIgdHlwZT0icGNpIiBpbmRleD0iNCIgbW9kZWw9
InBjaWUtcm9vdC1wb3J0Ij4KICAgICAgPG1vZGVsIG5hbWU9InBjaWUtcm9vdC1wb3J0Ii8+
CiAgICAgIDx0YXJnZXQgY2hhc3Npcz0iNCIgcG9ydD0iMHhiIi8+CiAgICAgIDxhZGRyZXNz
IHR5cGU9InBjaSIgZG9tYWluPSIweDAwMDAiIGJ1cz0iMHgwMCIgc2xvdD0iMHgwMSIgZnVu
Y3Rpb249IjB4MyIvPgogICAgPC9jb250cm9sbGVyPgogICAgPGNvbnRyb2xsZXIgdHlwZT0i
cGNpIiBpbmRleD0iNSIgbW9kZWw9InBjaWUtcm9vdC1wb3J0Ij4KICAgICAgPG1vZGVsIG5h
bWU9InBjaWUtcm9vdC1wb3J0Ii8+CiAgICAgIDx0YXJnZXQgY2hhc3Npcz0iNSIgcG9ydD0i
MHhjIi8+CiAgICAgIDxhZGRyZXNzIHR5cGU9InBjaSIgZG9tYWluPSIweDAwMDAiIGJ1cz0i
MHgwMCIgc2xvdD0iMHgwMSIgZnVuY3Rpb249IjB4NCIvPgogICAgPC9jb250cm9sbGVyPgog
ICAgPGNvbnRyb2xsZXIgdHlwZT0icGNpIiBpbmRleD0iNiIgbW9kZWw9InBjaWUtcm9vdC1w
b3J0Ij4KICAgICAgPG1vZGVsIG5hbWU9InBjaWUtcm9vdC1wb3J0Ii8+CiAgICAgIDx0YXJn
ZXQgY2hhc3Npcz0iNiIgcG9ydD0iMHhkIi8+CiAgICAgIDxhZGRyZXNzIHR5cGU9InBjaSIg
ZG9tYWluPSIweDAwMDAiIGJ1cz0iMHgwMCIgc2xvdD0iMHgwMSIgZnVuY3Rpb249IjB4NSIv
PgogICAgPC9jb250cm9sbGVyPgogICAgPGNvbnRyb2xsZXIgdHlwZT0ic2F0YSIgaW5kZXg9
IjAiPgogICAgICA8YWRkcmVzcyB0eXBlPSJwY2kiIGRvbWFpbj0iMHgwMDAwIiBidXM9IjB4
MDAiIHNsb3Q9IjB4MWYiIGZ1bmN0aW9uPSIweDIiLz4KICAgIDwvY29udHJvbGxlcj4KICAg
IDxzZXJpYWwgdHlwZT0icHR5Ij4KICAgICAgPHRhcmdldCB0eXBlPSJpc2Etc2VyaWFsIiBw
b3J0PSIwIj4KICAgICAgICA8bW9kZWwgbmFtZT0iaXNhLXNlcmlhbCIvPgogICAgICA8L3Rh
cmdldD4KICAgIDwvc2VyaWFsPgogICAgPGNvbnNvbGUgdHlwZT0icHR5Ij4KICAgICAgPHRh
cmdldCB0eXBlPSJzZXJpYWwiIHBvcnQ9IjAiLz4KICAgIDwvY29uc29sZT4KICAgIDxpbnB1
dCB0eXBlPSJtb3VzZSIgYnVzPSJwczIiLz4KICAgIDxpbnB1dCB0eXBlPSJrZXlib2FyZCIg
YnVzPSJwczIiLz4KICAgIDxhdWRpbyBpZD0iMSIgdHlwZT0ibm9uZSIvPgogICAgPHdhdGNo
ZG9nIG1vZGVsPSJpdGNvIiBhY3Rpb249InJlc2V0Ii8+CiAgICA8bWVtYmFsbG9vbiBtb2Rl
bD0idmlydGlvIj4KICAgICAgPGFkZHJlc3MgdHlwZT0icGNpIiBkb21haW49IjB4MDAwMCIg
YnVzPSIweDA0IiBzbG90PSIweDAwIiBmdW5jdGlvbj0iMHgwIi8+CiAgICA8L21lbWJhbGxv
b24+CiAgPC9kZXZpY2VzPgogIDxzZWNsYWJlbCB0eXBlPSJkeW5hbWljIiBtb2RlbD0iZGFj
IiByZWxhYmVsPSJ5ZXMiLz4KPC9kb21haW4+

--------------jAmz1BtPPXML2ujfVW3AXWi5--
