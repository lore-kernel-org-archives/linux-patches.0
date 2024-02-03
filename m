Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9313137B;
	Sat,  3 Feb 2024 01:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706922750; cv=none; b=Exjfs2iBBsOl7jPXrQhYxxRat/SsNkB50OXBPzbgx4sxnHoP6v1zI1N32kE+R1+MCubvFKp7bjsZYPsGZokdNJ3F65/48I9IZtWNmttUm33oe3PhsSThsUb2i+IWID0ORbPSOBtB+8HBScs/yzLdeeObus+UYEbqZEXlggDPUZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706922750; c=relaxed/simple;
	bh=2DiNg+AV7VuJ2EwtZlmsfWoLff7eCS+w/xEf/uARMwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOBT9paUM5T2yPtD4/BI8diTndNTnk6rQp8JPB0pSW49zRL8SNTQe2YK5O5jZqWdzMie4EKYpVVId9GmXOP+jNTG3iw5jOfQqUlICr7Mr0AGEagG3WDU2n1vUTui2g5GKwhbMDy8wjPDnqwp+si72iODQ7xcGo0/qSeb/WMX89g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNE9eojQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNE9eojQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C03C433C7;
	Sat,  3 Feb 2024 01:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706922749;
	bh=2DiNg+AV7VuJ2EwtZlmsfWoLff7eCS+w/xEf/uARMwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eNE9eojQwUc6DjSQklExt40eZUahaqQYQkmoWPFEI0OXb+T0MElo6Zy1Wp1FhDxY2
	 T2PKMk+fuVx/ng/Wqu/B6guq2BJ9F1WcNPlcHy3+rj18P7Tzg3/T5KjO/rqzT1fz9A
	 H2Ci8pHC+kcPdmwCj0fOQQakETltS0lmL3WwK3D4=
Date: Fri, 2 Feb 2024 17:12:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Jiri Slaby <jirislaby@kernel.org>,
	Alexander Potapenko <glider@google.com>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.7 125/346] mm/sparsemem: fix race in accessing
 memory_section->usage
Message-ID: <2024020221-disburse-scrawny-ff90@gregkh>
References: <20240129170016.356158639@linuxfoundation.org>
 <20240129170020.057681007@linuxfoundation.org>
 <81752462-c6c7-4a65-b9f2-371573e15499@kernel.org>
 <2024013044-snowiness-abreast-2a47@gregkh>
 <7d963e3f-2677-4459-b60e-2590d6cddc79@suse.cz>
 <CANpmjNOdRXcok7oyQ=-G7iYthy7f6zHMjJ+TZqGP+vzwRT4+pg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANpmjNOdRXcok7oyQ=-G7iYthy7f6zHMjJ+TZqGP+vzwRT4+pg@mail.gmail.com>

On Fri, Feb 02, 2024 at 10:50:26AM +0100, Marco Elver wrote:
> On Fri, 2 Feb 2024 at 10:44, Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> >
> >
> > On 1/30/24 17:21, Greg Kroah-Hartman wrote:
> > > On Tue, Jan 30, 2024 at 07:00:36AM +0100, Jiri Slaby wrote:
> > >> On 29. 01. 24, 18:02, Greg Kroah-Hartman wrote:
> > >>> 6.7-stable review patch.  If anyone has any objections, please let me know.
> > >>>
> > >>> ------------------
> > >>>
> > >>> From: Charan Teja Kalla <quic_charante@quicinc.com>
> > >>>
> > >>> commit 5ec8e8ea8b7783fab150cf86404fc38cb4db8800 upstream.
> > >>
> > >> Hi,
> > >>
> > >> our machinery (git-fixes) says, this is needed as a fix:
> > >> commit f6564fce256a3944aa1bc76cb3c40e792d97c1eb
> > >> Author: Marco Elver <elver@google.com>
> > >> Date:   Thu Jan 18 11:59:14 2024 +0100
> > >>
> > >>     mm, kmsan: fix infinite recursion due to RCU critical section
> > >>
> > >>
> > >> Leaving up to the recipients to decide, as I have no idea…
> >
> > Let's Cc the people involved in f6564fce256a394
> >
> > > That commit just got merged into Linus's tree, AND it is not marked for
> > > stable, which is worrying as I have to get the developers's approval to
> > > add any non-cc-stable mm patch to the tree because they said they would
> > > always mark them properly :)
> > >
> > > So I can't take it just yet...
> 
> So 5ec8e8ea8b7783fab150cf86404fc38cb4db8800 is being backported to
> stable, which means that the issue that f6564fce256a394 fixed will be
> present in stable. I didn't mark f6564fce256a394 as stable as the
> problem doesn't exist in stable (yet), but if the problem-introducing
> commit is being backported, then yes, please also backport
> f6564fce256a394 to stable.

Thanks, now queued up.

greg k-h
